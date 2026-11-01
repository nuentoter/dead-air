# DEAD AIR — Technical Implementation Plan

**Status:** Implementation plan v0.1  
**Engine proposal:** Godot 4.x / GDScript  
**Target:** Offline landscape Android; desktop test loop first.

## 1. Architecture
Keep the first slice small and data-driven.
- project.godot: landscape project configuration and application metadata.
- scenes/main.tscn: one root scene with script-built interface to avoid unnecessary assets.
- scripts/main.gd: screen composition, navigation, controls, view rendering, actions.
- scripts/game_state.gd: canonical state, mutations, save/load, stable IDs, reports and notes.
- scripts/content_catalog.gd: immutable authored signal/document/assignment/message data.
- tests/: manual verification checklist and automated test harness where feasible.
- docs/: design and implementation contracts.

The catalog is the source for authored content; the save-state layer stores player mutations. UI nodes are projections of state, not the only copy of narrative originals.

## 2. Data model
Authored event: ID, frequency, mode, event-time label, time basis, identifier, sequence, strength, classification, transcript, provenance, essential flag.

Document: ID, title, source, claimed event time, clock basis, body, status, version, essential flag, related IDs.

Save state: schema version, current section, receiver power/frequency/mode, selected event, retained and recorded IDs, notes, reports, assignment statuses, seen messages, settings, event log.

Authored IDs never change. Player-created IDs use saved monotonic counters. Submitted reports are immutable; revisions append new records. Corrections/annotations are linked new records.

## 3. Persistence
- Save to user://dead_air_save.json.
- Serialize to a temporary path before replacing the prior save.
- Include schema_version.
- Missing/invalid save falls back to clean defaults with a clear notice; never falsely claim a save loaded.
- Save after meaningful mutations and on lifecycle notifications when available.
- No time advance while backgrounded/closed. No network calls.

## 4. Receiver simulation
Curated deterministic events only—not RF simulation.
- Tuning changes displayed frequency and matching-event list.
- Mode affects decoding, never removes essential evidence from archive.
- SEEK advances to next authored qualifying event; no qualifying event means a truthful no-result message.
- Waterfall is deterministic from authored event metadata; no random corruption or hidden-image payload.
- Event selection shows exact metadata and transcript.
- Manual recording appends event ID and provenance; system retention remains separate.

## 5. Audio and speech
- Receiver ambience is locally generated and optional.
- The formant speech engine synthesizes authored transcript text locally into compact mono PCM; no online service, system TTS dependency, or microphone permission is used.
- Speech playback is explicit/on-demand; written transcripts remain authoritative and all essential clues remain readable.
- Package ceiling is 50 MB total: 25 MB base plus up to 25 MB reserved for audio/speech technology and voice assets. The reserved amount is not a target to fill.

## 6. UI
Use Godot Control nodes, Containers, and scrollable panels. Landscape layout: top status strip, persistent six-destination navigation, content workspace, status notice. Touch targets and labels must work at phone scale. First slice may omit audio playback, but must label that clearly and keep text equivalents. No fake errors, flicker, or deceptive controls.

## 7. Minimum tests
1. Fresh state retains all essential event IDs.
2. Tuning/mode/SEEK never deletes events.
3. Essential event opens from archive when receiver is off.
4. Notes persist through save/load.
5. Submitted reports are immutable; correction creates a new record.
6. Report closes assignment, not case thread.
7. M-07 stays 18:00; M-08 stays 18:17/18:19/18:23.
8. M-09 stays 18:19/18:21/18:23.
9. Matching identifiers/sequences do not infer source.
10. Save/load preserves section, receiver state, notes, reports, settings.

## 8. Verification commands
With Godot 4 installed:
- godot --headless --path . --editor --quit
- godot --headless --path . --quit-after 3
- Android export requires configured Android SDK/JDK and export preset; measure actual APK/AAB size.
These must be run before claiming the build tested.

## 9. Risks
Godot version differences may affect settings and themes; procedural UI needs device tuning; under-25-MB is unverified; GDScript is not validated until run in Godot; GitHub-only edits must be cloned/downloaded to a local Godot environment for proper build testing.


## 9. Current implementation coverage

The current code implements the data model, local persistence, six primary sections, text-size controls, deterministic authored events, tuning/mode match feedback, manual-record provenance, archive search, notebook notes, required-document review, report submission/addenda, and administrative review. It does not yet implement physical scan behavior, true waterfall rendering, audio, Android export, or a complete eight-hour simulated clock. The gap between design and code is tracked in IMPLEMENTATION_STATUS.md.
