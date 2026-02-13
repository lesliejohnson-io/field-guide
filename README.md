# Field Guide

## From Deterministic Capture to Agentic Orchestration

Field Guide explores how longitudinal health research systems evolve from rigid survey engines into adaptive, agentic infrastructure.

---

## Context

COHRA1 was a 700-household NIH-funded longitudinal study examining oral health disparities across rural Appalachia.

The original system relied on:

- Paper surveys  
- Manual intake workflows  
- Cross-site protocol variance  
- Multi-day data processing  
- Cognitive overload and response degradation  

It captured data.

It did not manage entropy.

---

## Deterministic System (v1)

The first evolution replaced paper with a structured tablet workflow:

- 120+ branching survey questions  
- 3rd-grade reading-level rewrite  
- Offline-first encrypted storage  
- Bluetooth sync to central research database  
- Standardized clinical capture (DMFT)  
- DNA + microbial sample registry  
- Environmental fluoride data linkage  

Participation doubled.  
Completion time dropped 82%.  
Data latency fell from days to hours.  

## Architecture:

```mermaid
flowchart LR

  subgraph Field_Setting
    P1[Participants]
    P2[Field Researcher]
    P3[Dental Examiner]
  end

  subgraph Tablet_System
    T1[Tablet UI]
    T2[Survey Engine]
    T3[Validation]
    T4[Visit Memory]
    T5[Offline Store]
  end

  subgraph Data_Platform
    S1[Sync Layer]
    S2[(Research Database)]
  end

  P1 --> T1
  P2 --> T1
  P3 --> T1
  T1 --> T2 --> T3 --> T4 --> T5
  T5 --> S1 --> S2
```
## The Limitation

Deterministic systems are static.

They cannot:

- Detect fatigue in real time  
- Adapt phrasing dynamically  
- Reconcile contradictions proactively  
- Monitor trust erosion  
- Coordinate multi-actor flow  

They reduce friction.  
They do not reason.

---

## Agentic Evolution (v2)

This project reimagines Field Guide as a multi-agent orchestration system.

### Core Agents

**Conversational Capture**  
Adaptive phrasing and clarification.

**Trust & Engagement**  
Fatigue and dropout detection.

**Data Quality**  
Real-time anomaly and contradiction checks.

**Clinic Flow**  
Operational coordination across spaces.

**Research Orchestrator**  
Policy enforcement and routing.

**Longitudinal Memory**  
State persistence across years.

---

## Architecture

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
```

## What This Demonstrates

- Human-in-the-loop system design  
- Distributed orchestration  
- Offline-first state management  
- Variance reduction as a design goal  
- Agent layering architecture  
- Audit-aware AI infrastructure  

This is not a chatbot.  

It is intelligence infrastructure.

---

## Demo

Launch → *(link here)*

### Features

- Adaptive rephrasing (three reading tiers)  
- Fatigue detection and nudges  
- Contradiction flagging  
- Offline sync simulation  
- Audit trail visualization  

Field Guide evolved from a deterministic survey engine into an agentic research orchestration system.

