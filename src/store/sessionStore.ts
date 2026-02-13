import { create } from "zustand";
import { nanoid } from "nanoid";

export type ReadingLevel = "simple" | "standard" | "clinical";

export type AuditEventType =
  | "reading_level_changed"
  | "answer_saved"
  | "fatigue_updated"
  | "nudge_shown"
  | "nudge_action";

export type AuditEvent = {
  id: string;
  ts: number;
  type: AuditEventType;
  message: string;
  meta?: Record<string, any>;
};

type SessionState = {
  readingLevel: ReadingLevel;
  answers: Record<string, string | number | "">;
  audit: AuditEvent[];

  fatigue: number;
  nudgeShown: boolean;

  setReadingLevel: (level: ReadingLevel) => void;
  setAnswer: (questionId: string, value: string | number | "") => void;

  bumpFatigue: (amount?: number) => void;
  showNudge: () => void;
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

  setAnswer: (questionId, value) => {
    set((state) => ({
      answers: { ...state.answers, [questionId]: value },
    }));

    get().addAudit({
      type: "answer_saved",
      message: `Answer saved: ${questionId}`,
      meta: { questionId, value },
    });

    get().bumpFatigue(1);
  },

  bumpFatigue: (amount = 1) => {
    const next = get().fatigue + amount;

    set({ fatigue: next });

    get().addAudit({
      type: "fatigue_updated",
      message: `Fatigue +${amount} (now ${next})`,
      meta: { amount, fatigue: next },
    });

    if (next >= 5 && !get().nudgeShown) {
      get().showNudge();
    }
  },

  showNudge: () => {
    set({ nudgeShown: true });

    get().addAudit({
      type: "nudge_shown",
      message: "Nudge shown: fatigue support",
      meta: { kind: "fatigue_support" },
    });
  },

  dismissNudge: () => {
    const reduced = Math.max(0, get().fatigue - 3);

    set({
      nudgeShown: false,
      fatigue: reduced,
    });

    get().addAudit({
      type: "nudge_action",
      message: "Nudge dismissed: pause",
      meta: { action: "pause" },
    });
  },

  reset: () => {
    set({
      readingLevel: "standard",
      answers: {},
      audit: [],
      fatigue: 0,
      nudgeShown: false,
    });
  },
}));
