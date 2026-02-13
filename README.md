## Field Guide – Agentic Architecture

Field Guide evolved from a deterministic survey engine into an agentic research orchestration system.

```mermaid
flowchart LR

  subgraph Field_Setting
    P1[Participants Parent Child]
    P2[Field Researcher]
    P3[Dental Examiner]
    P4[Clinic Staff]
  end

  subgraph Tablet_System_Original
    T1[Tablet App UI Voice Touch]
    T2[Survey Orchestrator 120+ Items]
    T3[Validation Layer Required Fields]
    T4[Household Visit Memory]
    T5[Offline Store Encrypted Cache Sync Queue]
  end

  subgraph Sync_And_Data_Platform
    S1[Bluetooth Batch Sync]
    S2[(Central Research Database)]
    S3[(Bio Sample Registry DNA Microbial)]
    S4[(Environmental Lab Data Fluoride)]
  end

  subgraph Agentic_Future_COHRA2
    A1[Conversational Capture Agent]
    A2[Trust Engagement Agent]
    A3[Clinic Flow Agent]
    A4[Data Quality Agent]
    A5[Research Orchestrator Agent]
    A6[(Longitudinal Memory Layer Structured DB Vector DB)]
    A7[Insight Engine Risk Flags]
    A8[Audit Compliance Layer]
    A9[Human In The Loop Review]
  end

  %% Original flows
  P1 --> T1
  P2 --> T1
  P3 --> T1

  T1 --> T2 --> T3 --> T4 --> T5
  T5 --> S1 --> S2
  S1 --> S3
  S1 --> S4

  %% Agentic overlay
  P1 --> A1
  P2 --> A5
  P4 --> A3

  A1 --> A5
  A2 --> A5
  A3 --> A5
  A4 --> A5

  A5 --> A6
  A5 --> S2
  A5 --> A8
  A8 --> A9
  A9 --> A5

  S2 --> A7
  A6 --> A7
  A7 --> A5
