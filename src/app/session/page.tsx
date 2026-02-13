"use client";

import { useState } from "react";
import { modules } from "@/lib/data/schema";
import { questions } from "@/lib/data/questions";
import {
  Tabs,
  TabsList,
  TabsTrigger,
  TabsContent,
} from "@/components/ui/tabs";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ThemeToggle } from "@/components/theme-toggle";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export default function SessionPage() {
  const [activeModule, setActiveModule] = useState(modules[0].id);
  const [readingLevel, setReadingLevel] =
    useState<"simple" | "standard" | "clinical">("standard");

  const moduleQuestions = questions.filter(
    (q) => q.module === activeModule
  );

  return (
    <div className="min-h-screen bg-background text-foreground flex">
      {/* Left Rail */}
      <aside className="w-72 border-r border-border/60 bg-muted/20 p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground mb-4">
          Modules
        </h2>

        <div className="space-y-2">
          {modules.map((module) => (
            <button
              key={module.id}
              onClick={() => setActiveModule(module.id)}
              className={`w-full text-left px-3 py-2 rounded-lg text-sm transition ${
                activeModule === module.id
                  ? "bg-background shadow-sm border border-border/60 text-primary font-medium"
                  : "hover:bg-background/60"
              }`}
            >
              {module.label}
            </button>
          ))}
        </div>
      </aside>

      {/* Main Panel */}
      <main className="flex-1 p-8">
        <div className="mx-auto max-w-5xl">
          {/* Header */}
          <div className="flex items-start justify-between mb-6">
            <div>
              <h1 className="text-2xl font-semibold tracking-tight">
                Field Guide
              </h1>
              <p className="text-sm text-muted-foreground mt-1">
                Session •{" "}
                <span className="font-medium text-foreground">
                  {activeModule}
                </span>
              </p>
            </div>
            <ThemeToggle />
          </div>

          <Tabs defaultValue="capture" className="mt-4">
            <TabsList>
              <TabsTrigger value="capture">Capture</TabsTrigger>
              <TabsTrigger value="audit">Audit</TabsTrigger>
              <TabsTrigger value="sync">Sync</TabsTrigger>
            </TabsList>

            {/* CAPTURE TAB */}
            <TabsContent value="capture">
              <Card className="mt-6">
                <CardHeader className="flex flex-row items-center justify-between">
                  <CardTitle className="text-base">Capture</CardTitle>

                  <div className="w-[180px]">
                    <Select
                      value={readingLevel}
                      onValueChange={(v) =>
                        setReadingLevel(v as any)
                      }
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Reading level" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="simple">Simple</SelectItem>
                        <SelectItem value="standard">
                          Standard
                        </SelectItem>
                        <SelectItem value="clinical">
                          Clinical
                        </SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </CardHeader>

                <CardContent className="space-y-6">
                  {moduleQuestions.length === 0 ? (
                    <p className="text-sm text-muted-foreground">
                      No questions in this module yet.
                    </p>
                  ) : (
                    moduleQuestions.map((question) => (
                      <div key={question.id} className="space-y-2">
                        <p className="font-medium">
                          {question.prompt[readingLevel]}
                        </p>

                        {question.type === "number" && (
                          <input
                            type="number"
                            className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm"
                          />
                        )}

                        {question.type === "text" && (
                          <input
                            type="text"
                            className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm"
                          />
                        )}

                        {question.type === "select" && (
                          <select className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm">
                            <option value="">Select…</option>
                            {question.options?.map((opt) => (
                              <option key={opt} value={opt}>
                                {opt}
                              </option>
                            ))}
                          </select>
                        )}
                      </div>
                    ))
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* AUDIT TAB */}
            <TabsContent value="audit">
              <Card className="mt-6">
                <CardHeader>
                  <CardTitle className="text-base">
                    Audit
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-sm text-muted-foreground">
                  Audit timeline placeholder
                </CardContent>
              </Card>
            </TabsContent>

            {/* SYNC TAB */}
            <TabsContent value="sync">
              <Card className="mt-6">
                <CardHeader>
                  <CardTitle className="text-base">
                    Sync
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-sm text-muted-foreground">
                  Sync queue placeholder
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </main>
    </div>
  );
}
