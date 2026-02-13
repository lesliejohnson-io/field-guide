"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { useSessionStore } from "@/store/sessionStore";

export function AgentBar() {
  const fatigue = useSessionStore((s) => s.fatigue);
  const nudgeShown = useSessionStore((s) => s.nudgeShown);
  const nudgeReason = useSessionStore((s) => s.nudgeReason);
  const nudgeSignals = useSessionStore((s) => s.nudgeSignals);
  const setReadingLevel = useSessionStore((s) => s.setReadingLevel);
  const dismissNudge = useSessionStore((s) => s.dismissNudge);
  const addAudit = useSessionStore((s) => s.addAudit);
  const latestSignal = nudgeSignals[0];

  const reasonHint = (() => {
    switch (latestSignal?.type) {
      case "churn":
        return "Suggestion: lock one answer pass and avoid repeated rewrites.";
      case "hesitation":
        return "Suggestion: switch to simpler language and answer quickly with a best estimate.";
      case "contradiction":
        return "Suggestion: review related answers for consistency before moving on.";
      default:
        return "Suggestion: simplify language and pause briefly.";
    }
  })();

  return (
    <AnimatePresence>
      {nudgeShown && (
        <motion.div
          initial={{ opacity: 0, y: -6 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -6 }}
          transition={{ duration: 0.18 }}
          className="rounded-lg border border-border/60 bg-background/80 backdrop-blur px-4 py-3 shadow-sm"
        >
          <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div className="space-y-1">
              <div className="text-sm font-medium">
                Agent intervention: reducing cognitive load
              </div>
              <div className="text-xs text-muted-foreground">
                Reason: {nudgeReason ?? "Fatigue threshold reached"}.
              </div>
              <div className="text-xs text-muted-foreground">
                Fatigue: {fatigue}. {reasonHint}
              </div>
            </div>

            <div className="flex gap-2">
              <Button
                size="sm"
                onClick={() => {
                  setReadingLevel("simple");
                  addAudit({
                    type: "nudge_action",
                    message: "Agent action: simplify language",
                    meta: {
                      action: "simplify",
                      reason: nudgeReason,
                      signalType: latestSignal?.type,
                    },
                  });
                  dismissNudge();
                }}
              >
                Simplify
              </Button>

              <Button
                size="sm"
                variant="outline"
                onClick={() => {
                  addAudit({
                    type: "nudge_action",
                    message: "Agent action: pause",
                    meta: {
                      action: "pause",
                      reason: nudgeReason,
                      signalType: latestSignal?.type,
                    },
                  });
                  dismissNudge();
                }}
              >
                Pause
              </Button>
            </div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
