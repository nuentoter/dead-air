# DEAD AIR — Backup Index and Continuity Policy

This file is the quick recovery index for the DEAD AIR project. The GitHub repository is the canonical durable copy of the working design, narrative, and prototype source files listed below.

Repository: https://github.com/nuentoter/dead-air

## Current backed-up project documents

### Core design and canon
- [README](../README.md) — project entry point, current status, and core guardrails.
- [Game Design Overview](GAME_DESIGN.md) — core concept, platform, player loop, receiver, archive, UI, audio, and constraints.
- [Player Interface & Navigation Specification](PLAYER_INTERFACE_AND_NAVIGATION_SPEC.md) — landscape layout, navigation, receiver/recordings/archive/notebook/assignments/messages screens, provenance, accessibility, and UI acceptance criteria.
- [Receiver Interaction & Signal Behavior Specification](RECEIVER_INTERACTION_AND_SIGNAL_SPEC.md) — receiver controls, scanning, modes, signal processing, recordings, decode behavior, and recovery rules.
- [Shift & Assignment Progression Specification](SHIFT_AND_ASSIGNMENT_PROGRESSION_SPEC.md) — shift lifecycle, simulated time, routine duties, assignment/report states, supervisor review, evidence discovery, and save/resume behavior.
- [Prioritized Design Decision Register](PRIORITIZED_DESIGN_DECISION_REGISTER.md) — decision priorities, dependencies, prototype tests, guardrails, and design-ready criteria.
- [Canonical Identifiers & Time Register](CANONICAL_IDENTIFIERS_AND_TIME_REGISTER.md) — canonical-name inventory, IDs, timestamp fields, frequencies, placeholders, and unresolved cross-document conflicts.
- [Master Chronology & Evidence Ledger](MASTER_CHRONOLOGY_EVIDENCE_LEDGER.md) — evidence ledger, chronology anchors, contradiction matrix, Silent Site evidence chain, ambient threads, and placeholder register.
- [Canon Decisions & Open Questions](CANON_AND_OPEN_QUESTIONS.md) — established working canon, provisional details, unresolved decisions, and guardrails.
- [Assignment Evidence Dependency Map](ASSIGNMENT_EVIDENCE_DEPENDENCY_MAP.md) — assignment register, core evidence paths, optional branches, knowledge gates, and recovery rules.

### Release and implementation
- [First Release Scope & Acceptance](FIRST_RELEASE_SCOPE_AND_ACCEPTANCE.md) — first playable scope and release gates.
- [Ending & Disclosure Structure](ENDING_AND_DISCLOSURE_STRUCTURE.md) — uncertainty-preserving ending.
- [Technical Implementation Plan](TECHNICAL_IMPLEMENTATION_PLAN.md) — Godot structure, data model, persistence, and tests.
- [Implementation Test Checklist](IMPLEMENTATION_TEST_CHECKLIST.md) — repeatable verification checklist.
- [Implementation Status](IMPLEMENTATION_STATUS.md) — implemented prototype features, verified headless checks, and unverified items.
- [Build & Run Guide](BUILD_AND_RUN.md) — local Godot run, headless checks, and Android export prerequisites.

### Story and player-facing content
- [Opening Shift Playable Script](../story/OPENING_SHIFT_PLAYABLE_SCRIPT.md) — handover, onboarding, first NR-041 detection, registry lookup, report, and supervisor closure.
- [Main-Story Document Packet](../story/MAIN_STORY_DOCUMENT_PACKET.md) — draft incident-file documents, post-shutdown appendix, Communications Record 04-C, decoding worksheet, and follow-up correspondence.
- [Main Story Assignment Scripts](../story/MAIN_STORY_ASSIGNMENT_SCRIPTS.md) — player-facing assignment interactions and report flows for A-003 through A-006.

## Backup and change policy

1. Any substantial design, canon, chronology, evidence, assignment, receiver, interface, or narrative work created for DEAD AIR should be committed to this repository during the same work session whenever practical.
2. Update the README and this index when adding a major project document, so the latest work remains discoverable.
3. Preserve contradictions, unresolved questions, provisional labels, and placeholders unless the project owner explicitly approves a canon change.
4. The project owner has now explicitly requested continued development through implementation. Keep code small, testable, and tied to the release contract; never claim a build is verified unless it has actually been run.
5. Treat Git history as the change trail. Prefer new commits and explicit revisions over silently replacing project history.
6. This repository currently backs up the working Markdown documents listed above. Original binary attachments (such as DOCX files) are not claimed as repository copies unless separately committed in a supported format.

### Prototype source files
- [Godot project configuration](../project.godot) and [main scene](../scenes/main.tscn).
- [Main UI](../scripts/main.gd), [game state and persistence](../scripts/game_state.gd), and [authored content catalog](../scripts/content_catalog.gd).
- [Headless self-test](../tests/self_test.gd) and [GitHub Actions workflow](../.github/workflows/godot-check.yml).

## Current implementation status

The first workstation prototype is present. Godot 4.3 headless parse/startup, UI-flow, and integrity checks pass on commit 99bc8edb10c0ba800933e88aab59be1983b5a899. Android export, physical-device layout, and the under-25-MB target remain unvalidated.
