# Field Guide — Tablet Research Experience Demo

A voice-enabled, tablet-based survey experience designed to rebuild trust in rural health research environments.

This demo recreates the redesigned workflow from an NIH-funded Appalachian health study where paper surveys were causing cognitive overload and eroding trust.

## Purpose

This repository demonstrates:

* Tablet-first layout architecture (fixed rail + content model)
* Trust-forward UX principles
* Mock survey flow with progress tracking
* Voice-enabled question playback (ElevenLabs assets)
* Offline-first demo experience (Flutter Web)

## Status

Currently implemented:

* Fixed tablet scaffold
* Interactive left navigation rail
* Dashboard placeholder
* Structured build process via scoped tickets

In progress:

* Dashboard content + primary CTA
* Survey question flow
* Voice playback integration

## Run Locally

```
flutter run -d chrome
```

## Design Principles

* Primary actions visible above the fold
* Cognitive load reduction
* Clear system status
* Technology serving trust, not spectacle
