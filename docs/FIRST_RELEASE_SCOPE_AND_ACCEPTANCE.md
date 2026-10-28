# DEAD AIR — First Release Scope & Acceptance

**Status:** Working release contract v0.1  
**Date:** 28 October 2026

## 1. Release promise
A compact, single-player, offline, landscape-first Android investigative radio simulation. It demonstrates a complete shift, receiver interaction, retained evidence, archive searches, notebook notes, report submission, supervisor review, and a short main-story arc ending in administrative closure without resolving the central phenomenon.

This is a narrative-first vertical slice with stable, deterministic simulation—not the full imagined procedural radio simulator.

## 2. Platform and technical assumptions
- Engine proposal: Godot 4.x, GDScript, Control-node UI.
- Primary target: Android landscape; desktop run is the development/test target.
- Offline: no network, accounts, analytics, online AI, microphone, real SDR, or real speech recognition.
- Under-25-MB package is a goal, not a claim; validate after Android export.
- No third-party art/audio in the first slice. Use native controls, text, and lightweight procedural display elements.
- Local versioned JSON save with schema version; save after consequential actions.

## 3. Core playable loop
1. Open Site 04 handover and current assignment.
2. Power on receiver and inspect stable waterfall/event list.
3. Select a simulated event and inspect frequency, mode, time basis, confidence, transcript/decode.
4. Record or inspect retained event; tuning away never deletes it.
5. Search archive for NR-041 and retrieve the registry response.
6. Compare the first and recurring receptions.
7. Compare M-07's 18:00 shutdown claim with M-08's later entries.
8. Submit a factual report separating observation from hypothesis.
9. Receive Mara Venn's administrative response. Assignment closes; chronology and source remain unresolved.
10. Save/resume without loss or real-time pressure.

## 4. Required systems
### Must ship
- Six destinations: Receiver, Recordings, Archive, Notebook, Assignments, Messages.
- Landscape-safe layout and large touch targets.
- Deterministic authored signal events and consistent metadata.
- Simple tuning, mode selector, simulated waterfall, event selection, and SEEK that selects only authored events.
- Signal IDs SIG-0001 through SIG-0005.
- Transcript always available; recording provenance.
- Searchable archive with honest no-result states.
- Notes and source links.
- Opening assignments A-001/A-002 and main path A-003 through A-006.
- Report draft, permanent submitted version, supervisor review.
- Local save/load and schema version.
- Text-size and mute/audio settings; essential evidence recoverable regardless of live receiver use.

### Explicitly defer
Real DSP, live RF, SDR, microphone, speech recognition, online services, full procedural voice ecosystem, long ambient transmissions, complete Silent Site branch, branch-heavy endings, complex evidence board, 3D station, export-to-file, cloud saves, monetization, ads, analytics. Package size remains unverified until an Android export is measured.

## 5. First-release story boundary
The arc ends with the report administratively accepted while the central questions remain unresolved.

Essential findings:
- NR-041 appears in retained Site 04 events but has no entry in the searched registry.
- Numeric sequence 731904 repeats, with lower confidence than the identifier.
- M-07 says operations were discontinued and equipment secured at 18:00.
- M-08 lists activity at 18:17, 18:19, and 18:23.
- M-09 lists 18:19, 18:21, and 18:23, but its source/clock basis is not stated.
- These facts do not establish a common transmitter, independent original, deliberate alteration, AI responsibility, or what lies beyond the connection.

## 6. Acceptance and release gates
A release candidate fails if any essential clue is audio-only, permanently missable, silently rewritten, presented as proven by matching identifiers, or dependent on a server/microphone. Fake UI errors are prohibited.

**Gate A — Desktop vertical slice:** main scene loads; six sections navigate; core evidence is consistent; report/review works; save/load round trip works; no parser/runtime errors in tested path.

**Gate B — Android smoke test:** landscape on device/emulator; legible touch UI; suspend/resume preserves work; offline paths work; package size measured.

**Gate C — Content integrity:** audit IDs/times/frequencies; replay main arc with live reception ignored; verify ending preserves uncertainty.

A “first playable” means Gate A passed. It does not imply Android export or package-size validation.
