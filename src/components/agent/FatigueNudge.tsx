"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { useSessionStore } from "@/store/sessionStore";

export function FatigueNudge() {
  const fatigue = useSessionStore((s) => s.fatigue);
  const nudgeShown = useSessionStore((s) => s.nudgeShown);
  const setReadingLevel = useSessionStore((s) => s.setReadingLevel);
  const dismissNudge = useSessionStore((s) => s.dismissNudge);
  const addAudit = useSessionStore((s) => s.addAudit);

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
              <div className="text-sm font-medium">Want to simplify this?</div>
              <div className="text-xs text-muted-foreground">
                Fatigue signal: {fatigue}. I can reduce cognitive load.
              </div>
            </div>

            <div className="flex gap-2">
              <Button
                size="sm"
                onClick={() => {
                  setReadingLevel("simple");
                  addAudit({
                    type: "nudge_action",
                    message: "Nudge action: simplify reading level",
                    meta: { action: "simplify" },
                  });
                }}
              >
                Simplify
              </Button>

              <Button size="sm" variant="outline" onClick={dismissNudge}>
                Pause
              </Button>
            </div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
