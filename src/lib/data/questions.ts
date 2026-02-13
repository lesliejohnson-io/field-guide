export type ReadingLevel = "simple" | "standard" | "clinical";

export type Question = {
  id: string;
  module: string;
  type: "number" | "text" | "select";
  options?: string[];
  prompt: Record<ReadingLevel, string>;
};

export const questions: Question[] = [
  // Household
  {
    id: "household_size",
    module: "household",
    type: "number",
    prompt: {
      simple: "How many people live in your home?",
      standard: "How many people live in your household?",
      clinical: "Household size (number of residents)?",
    },
  },

  // Oral Health
  {
    id: "brushing_frequency",
    module: "oral",
    type: "number",
    prompt: {
      simple: "How many times do you brush your teeth each day?",
      standard: "On average, how many times per day do you brush your teeth?",
      clinical: "Mean daily toothbrushing frequency?",
    },
  },
  {
    id: "last_dental_visit",
    module: "oral",
    type: "select",
    options: ["Within 6 months", "6–12 months", "More than 1 year", "Never"],
    prompt: {
      simple: "When was your last dental visit?",
      standard: "When did you most recently see a dentist?",
      clinical: "Most recent dental examination timeframe?",
    },
  },

  // Stress
  {
    id: "stress_level",
    module: "stress",
    type: "select",
    options: ["Low", "Moderate", "High"],
    prompt: {
      simple: "How stressed do you feel most days?",
      standard: "How would you rate your typical stress level?",
      clinical: "Self-reported perceived stress level?",
    },
  },
  {
    id: "sleep_hours",
    module: "stress",
    type: "number",
    prompt: {
      simple: "About how many hours do you sleep most nights?",
      standard: "On average, how many hours of sleep do you get per night?",
      clinical: "Average nightly sleep duration (hours)?",
    },
  },

  // Dental Exam (demo fields)
  {
    id: "dmft_score",
    module: "exam",
    type: "number",
    prompt: {
      simple: "Dental exam score (demo): enter a number",
      standard: "DMFT score (demo): enter a number",
      clinical: "DMFT index value (Decayed, Missing, Filled Teeth)?",
    },
  },

  // Samples
  {
    id: "dna_sample_collected",
    module: "samples",
    type: "select",
    options: ["Yes", "No"],
    prompt: {
      simple: "Did we collect a DNA sample today?",
      standard: "Was a DNA sample collected during this visit?",
      clinical: "DNA specimen collected (Y/N)?",
    },
  },

  // Environment
  {
    id: "water_source",
    module: "environment",
    type: "select",
    options: ["City water", "Well water", "Bottled water", "Other"],
    prompt: {
      simple: "What kind of water do you drink most often?",
      standard: "Primary drinking water source?",
      clinical: "Primary household drinking water source classification?",
    },
  },
];
