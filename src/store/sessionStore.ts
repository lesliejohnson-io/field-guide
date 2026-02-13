import { create } from "zustand";
import { nanoid } from "nanoid";

export type ReadingLevel = "simple" | "standard" | "clinical";

export type AuditEventType =
  | "reading_level_changed"
  | "answer_saved"
  | "fatigue_updated"
  | "nudge_shown"
  | "nudge_action"
  | "churn_detected"
  | "hesitation_detected"
  | "contradiction_detected";

export type FatigueSignalType = "churn" | "hesitation" | "contradiction";

export type FatigueSignal = {
  type: FatigueSignalType;
  questionId?: string;
  message: string;
  ts: number;
};

export type AuditEvent = {
  id: string;
  ts: number;
  type: AuditEventType;
  message: string;
  meta?: Record<string, unknown>;
};

type SessionState = {
  readingLevel: ReadingLevel;
  answers: Record<string, string | number | "">;
  audit: AuditEvent[];

  fatigue: number;
  nudgeShown: boolean;
  nudgeReason: string | null;
  nudgeSignals: FatigueSignal[];
  inputFocusTs: Record<string, number>;
  answerEdits: Record<string, number>;

  setReadingLevel: (level: ReadingLevel) => void;
  setAnswer: (questionId: string, value: string | number | "") => void;
  noteQuestionFocus: (questionId: string) => void;

  bumpFatigue: (amount?: number, source?: "answer" | "time" | "signal") => void;
  showNudge: (reason: string, signal: FatigueSignal) => void;
  dismissNudge: () => void;

  addAudit: (event: Omit<AuditEvent, "id" | "ts">) => void;
  reset: () => void;
};

export const useSessionStore = create<SessionState>((set, get) => ({
  readingLevel: "standard",
  answers: {},
  audit: [],

  fatigue: 0,
  nudgeShown: false,
  nudgeReason: null,
  nudgeSignals: [],
  inputFocusTs: {},
  answerEdits: {},

  addAudit: (event) => {
    const entry: AuditEvent = {
      id: nanoid(),
      ts: Date.now(),
      ...event,
    };

    set((state) => ({
      audit: [entry, ...state.audit], // newest first
    }));
  },

  setReadingLevel: (level) => {
    set({ readingLevel: level });

    get().addAudit({
      type: "reading_level_changed",
      message: `Reading level set to ${level}`,
      meta: { level },
    });
  },

  noteQuestionFocus: (questionId) => {
    set((state) => ({
      inputFocusTs: { ...state.inputFocusTs, [questionId]: Date.now() },
    }));
  },

  setAnswer: (questionId, value) => {
    const now = Date.now();
    const current = get().answers[questionId];
    const wasAnswered = current !== undefined && current !== "";
    const isEdited = wasAnswered && current !== value;

    set((state) => {
      const nextEditCount = isEdited
        ? (state.answerEdits[questionId] ?? 0) + 1
        : state.answerEdits[questionId] ?? 0;

      return {
        answers: { ...state.answers, [questionId]: value },
        answerEdits: { ...state.answerEdits, [questionId]: nextEditCount },
      };
    });

    get().addAudit({
      type: "answer_saved",
      message: `Answer saved: ${questionId}`,
      meta: { questionId, value },
    });

    if (isEdited) {
      get().bumpFatigue(1, "answer");
    }

    const state = get();
    const focusTs = state.inputFocusTs[questionId];
    const hesitationMs = 12000;
    if (!wasAnswered && focusTs && now - focusTs >= hesitationMs) {
      const message = `Hesitation detected on ${questionId} (${Math.round(
        (now - focusTs) / 1000
      )}s before answering)`;
      const signal: FatigueSignal = {
        type: "hesitation",
        questionId,
        message,
        ts: now,
      };

      set((s) => ({ nudgeSignals: [signal, ...s.nudgeSignals].slice(0, 20) }));

      get().addAudit({
        type: "hesitation_detected",
        message,
        meta: { questionId, elapsedMs: now - focusTs },
      });

      get().bumpFatigue(1, "signal");
      if (!get().nudgeShown) {
        get().showNudge("Hesitation detected", signal);
      }
    }

    const editCount = get().answerEdits[questionId] ?? 0;
    if (editCount === 2) {
      const message = `Churn detected on ${questionId} (${editCount} edits)`;
      const signal: FatigueSignal = {
        type: "churn",
        questionId,
        message,
        ts: now,
      };

      set((s) => ({ nudgeSignals: [signal, ...s.nudgeSignals].slice(0, 20) }));

      get().addAudit({
        type: "churn_detected",
        message,
        meta: { questionId, edits: editCount },
      });

      get().bumpFatigue(2, "signal");
      if (!get().nudgeShown) {
        get().showNudge("Churn detected", signal);
      }
    }

    const answers = get().answers;
    const contradictions: Array<{
      key: string;
      reason: string;
      detail: Record<string, unknown>;
    }> = [];

    const stress = answers.stress_level;
    const sleep = answers.sleep_hours;
    if (stress === "Low" && typeof sleep === "number" && sleep <= 4) {
      contradictions.push({
        key: "stress_sleep",
        reason: "Contradiction detected: low stress with very low sleep",
        detail: { stress, sleep },
      });
    }

    const lastVisit = answers.last_dental_visit;
    const brushing = answers.brushing_frequency;
    if (
      lastVisit === "Never" &&
      typeof brushing === "number" &&
      brushing >= 2
    ) {
      contradictions.push({
        key: "dental_visit_brushing",
        reason:
          "Contradiction detected: never dental visit with regular brushing",
        detail: { lastVisit, brushing },
      });
    }

    contradictions.forEach((c) => {
      const signalDetail = c.detail;
      const alreadyLogged = get().audit.some(
        (e) => {
          if (e.type !== "contradiction_detected") {
            return false;
          }

          const meta = e.meta;
          if (!meta || meta.key !== c.key) {
            return false;
          }

          const detail =
            meta.detail && typeof meta.detail === "object"
              ? (meta.detail as Record<string, unknown>)
              : undefined;

          return (
            detail?.stress === signalDetail.stress &&
            detail?.sleep === signalDetail.sleep &&
            detail?.lastVisit === signalDetail.lastVisit &&
            detail?.brushing === signalDetail.brushing
          );
        }
      );

      if (alreadyLogged) {
        return;
      }

      const signal: FatigueSignal = {
        type: "contradiction",
        questionId,
        message: c.reason,
        ts: now,
      };
      set((s) => ({ nudgeSignals: [signal, ...s.nudgeSignals].slice(0, 20) }));

      get().addAudit({
        type: "contradiction_detected",
        message: c.reason,
        meta: { key: c.key, detail: c.detail },
      });

      get().bumpFatigue(2, "signal");
      if (!get().nudgeShown) {
        get().showNudge("Contradiction detected", signal);
      }
    });
  },

  bumpFatigue: (amount = 1, source = "answer") => {
    const next = get().fatigue + amount;

    set({ fatigue: next });

    get().addAudit({
      type: "fatigue_updated",
      message: `Fatigue +${amount} (now ${next})`,
      meta: { amount, fatigue: next, source },
    });

    if (next >= 5 && !get().nudgeShown) {
      const fallbackSignal: FatigueSignal = {
        type: "hesitation",
        message: "General fatigue threshold reached",
        ts: Date.now(),
      };
      get().showNudge("Fatigue threshold reached", fallbackSignal);
    }
  },

  showNudge: (reason, signal) => {
    set({ nudgeShown: true, nudgeReason: reason });

    get().addAudit({
      type: "nudge_shown",
      message: `Nudge shown: ${reason}`,
      meta: { kind: "fatigue_support", reason, signalType: signal.type },
    });
  },

  dismissNudge: () => {
    const reduced = Math.max(0, get().fatigue - 3);

    set({
      nudgeShown: false,
      nudgeReason: null,
      fatigue: reduced,
    });

    get().addAudit({
      type: "nudge_action",
      message: "Nudge dismissed: pause",
      meta: { action: "pause", reducedTo: reduced },
    });
  },

  reset: () => {
    set({
      readingLevel: "standard",
      answers: {},
      audit: [],
      fatigue: 0,
      nudgeShown: false,
      nudgeReason: null,
      nudgeSignals: [],
      inputFocusTs: {},
      answerEdits: {},
    });
  },
}));
