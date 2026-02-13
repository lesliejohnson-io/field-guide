import { create } from "zustand";
import { nanoid } from "nanoid";

export type ReadingLevel = "simple" | "standard" | "clinical";

export type AuditEventType = "reading_level_changed" | "answer_saved";

export type AuditEvent = {
  id: string;
  ts: number; // Date.now()
  type: AuditEventType;
  message: string;
  meta?: Record<string, any>;
};

type SessionState = {
  readingLevel: ReadingLevel;
  answers: Record<string, string | number>;
  audit: AuditEvent[];

  setReadingLevel: (level: ReadingLevel) => void;
  setAnswer: (questionId: string, value: string | number) => void;
  addAudit: (event: Omit<AuditEvent, "id" | "ts">) => void;
  reset: () => void;
};

export const useSessionStore = create<SessionState>((set, get) => ({
  readingLevel: "standard",
  answers: {},
  audit: [],

  addAudit: (event) => {
    const entry: AuditEvent = {
      id: nanoid(),
      ts: Date.now(),
      ...event,
    };
    set((state) => ({ audit: [entry, ...state.audit] })); // newest first
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
  },

  reset: () => {
    set({
      readingLevel: "standard",
      answers: {},
      audit: [],
    });
  },
}));
