"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { useSessionStore } from "@/store/sessionStore";

export function AgentBar() {
  const fatigue = useSessionStore((s) => s.fatigue);
  const nudgeShown = useSessionStore((s) => s.nudgeShown);
  const setReadingLevel = useSessionStore((s) => s.setReadingLevel);
  const dismissNudge = useSessionStore((s) => s.dismissNudge);
  const addAudit = useSessionStore((s) => s.addAudit);

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
                Fatigue signal: {fatigue}. I can simplify language and stabilize answers.
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
                    meta: { action: "simplify" },
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
                    meta: { action: "pause" },
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
