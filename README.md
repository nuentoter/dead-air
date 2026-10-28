# DEAD AIR

An offline, landscape-only Android radio-conspiracy horror game about ordinary monitoring work, contradictory records, and the limits of what an institution can account for.

**Development status:** first workstation prototype implemented. Godot 4.3 headless parsing, UI-flow, and integrity checks pass, including evidence-driven assignment progression and malformed-save recovery. The receiver plot now labels its time and frequency axes. Submitted reports are visible in read-only history with navigable citation IDs. Notebook entries let the player label a note as unclassified, observed fact, working hypothesis, or open question; linked-source titles are navigable without changing the note. The archive includes the closed incident-file cover (01-773), operations summary, appendix, and Communications Record 04-C. Supported related-record references can be opened directly, without treating an index relationship as proof of common origin. Assignment screens show persistent, evidence-driven progress checklists; A-005 now requires an explicit comparison review after M-08 and M-09 are opened. An arm64 debug APK previously exported at 24,330,645 bytes and a CI-signed release-mode APK at 22,966,724 bytes; both were under 25 MB. APK manifest audit confirmed no network or microphone permission and an explicit orientation entry; physical-device behavior remains unverified.

## Design documents

- [Backup Index & Continuity Policy](docs/BACKUP_AND_PROJECT_INDEX.md) — recovery index for project documents and the policy for keeping future work backed up.
- [Game Design Overview](docs/GAME_DESIGN.md) — pillars, player role, receiver simulation, UI, time, evidence, and opening experience.
- [Player Interface & Navigation Specification](docs/PLAYER_INTERFACE_AND_NAVIGATION_SPEC.md) — landscape layout, navigation, receiver/recordings/archive/notebook/assignments/messages screens, provenance, accessibility, and UI acceptance criteria.
- [Receiver Interaction & Signal Behavior Specification](docs/RECEIVER_INTERACTION_AND_SIGNAL_SPEC.md) — tuning, SEEK, modes, gain/bandwidth, recording, decoding, signal consistency, and evidence recovery.
- [Shift & Assignment Progression Specification](docs/SHIFT_AND_ASSIGNMENT_PROGRESSION_SPEC.md) — shift lifecycle, simulated time, routine duties, assignment/report states, supervisor review, evidence discovery, and save/resume behavior.
- [First Release Scope & Acceptance](docs/FIRST_RELEASE_SCOPE_AND_ACCEPTANCE.md) — bounded first playable, required systems, explicit deferrals, and release gates.
- [Ending & Disclosure Structure](docs/ENDING_AND_DISCLOSURE_STRUCTURE.md) — first-release closure that preserves the central uncertainty.
- [Technical Implementation Plan](docs/TECHNICAL_IMPLEMENTATION_PLAN.md) — project structure, state model, persistence, receiver simulation, and tests.
- [Implementation Test Checklist](docs/IMPLEMENTATION_TEST_CHECKLIST.md) — repeatable verification checklist.
- [Implementation Status](docs/IMPLEMENTATION_STATUS.md) — implemented prototype features, verified headless checks, known simplifications, and unverified items.
- [Build & Run Guide](docs/BUILD_AND_RUN.md) — local Godot run, headless checks, and Android export instructions.
- [Android Debug Export Workflow](.github/workflows/android-export.yml) — reproducible APK export attempt and artifact upload.
- [Prioritized Design Decision Register](docs/PRIORITIZED_DESIGN_DECISION_REGISTER.md) — open decisions ranked by priority, dependencies, prototype tests, non-negotiable guardrails, and criteria for design readiness.
- [Canonical Identifiers & Time Register](docs/CANONICAL_IDENTIFIERS_AND_TIME_REGISTER.md) — source-of-truth inventory for names, record IDs, timestamp conventions, frequencies, the working numeric sequence, Signal IDs, and remaining open questions.
- [Master Chronology & Evidence Ledger](docs/MASTER_CHRONOLOGY_EVIDENCE_LEDGER.md) — main-story evidence, contradiction rules, optional Silent Site branch, and canon guardrails.
- [Canon Decisions & Open Questions](docs/CANON_AND_OPEN_QUESTIONS.md) — working canon, remaining provisional details, unresolved decisions, and guardrails.
- [Assignment Evidence Dependency Map](docs/ASSIGNMENT_EVIDENCE_DEPENDENCY_MAP.md) — assignment register, core evidence paths, optional branches, knowledge gates, and recovery rules.
- [Opening Shift Playable Script](story/OPENING_SHIFT_PLAYABLE_SCRIPT.md) — handover, receiver onboarding, first NR-041 detection, registry conflict, report, and supervisor closure.
- [Main-Story Document Packet](story/MAIN_STORY_DOCUMENT_PACKET.md) — draft incident summary, post-shutdown appendix, Communications Record 04-C, NR-041 worksheet, and follow-up correspondence.
- [Main Story Assignment Scripts](story/MAIN_STORY_ASSIGNMENT_SCRIPTS.md) — player-facing interactions and report flows for A-003 through A-006, including archive discovery, comparisons, recovery paths, and Mara's review response.

## Core premise

The player is a technician at Remote Monitoring Site 04, employed by the fictional National Radio Monitoring Service (NRMS; current working canon). They monitor a simulated radio spectrum, record and decode transmissions, complete routine assignments, and investigate a recurring identifier: **NR-041**. That identifier conflicts with official registry records and eventually overlaps with a closed incident file concerning a government research facility.

The game must never confirm what lies beyond the connection, what it wants, or whether an experimental AI caused the incident.

## Non-negotiable design rules

- Evidence and records—not spectacle—carry the horror.
- The interface remains stable and truthful; no fake glitches or supernatural UI behavior.
- Audio adds atmosphere and information, but essential clues are always available as text.
- No essential clue can be permanently missed due to timing, tuning, recording length, or an early choice.
- Contradictory records remain contradictory; the archive never silently reconciles them.
- Administrative closure is not proof that an underlying question has been answered.
- Offline only: no accounts, online services, microphone, real SDR input, or online AI.
- Target Android package under 25 MB; Godot 4.3 is the current implementation engine and is validated by headless CI and Android export, while physical-device behavior remains unverified.
