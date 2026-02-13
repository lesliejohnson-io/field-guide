"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { useSessionStore } from "@/store/sessionStore";

export function FatigueNudge() {
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
        return "Suggestion: hold a single answer and avoid repeated changes.";
      case "hesitation":
        return "Suggestion: simplify language and answer with a best estimate.";
      case "contradiction":
        return "Suggestion: review linked answers for consistency.";
      default:
        return "Suggestion: reduce load with simpler phrasing.";
    }
  })();

  return (
    <AnimatePresence>
      {nudgeShown && (
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: 8 }}
          transition={{ duration: 0.18 }}
          className="rounded-lg border border-border/60 bg-muted/20 p-4"
        >
          <div className="flex items-start justify-between gap-4">
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
