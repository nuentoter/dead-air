# DEAD AIR — Backup Index and Continuity Policy

This file is the quick recovery index for the DEAD AIR project. The GitHub repository is the canonical durable copy of the working design and narrative documents listed below.

Repository: https://github.com/nuentoter/dead-air

## Current backed-up project documents

### Core design and canon
- [README](../README.md) — project entry point, current status, and core guardrails.
- [Game Design Overview](GAME_DESIGN.md) — core concept, platform, player loop, receiver, archive, UI, audio, and constraints.
- [Master Chronology & Evidence Ledger](MASTER_CHRONOLOGY_EVIDENCE_LEDGER.md) — evidence ledger, chronology anchors, contradiction matrix, Silent Site evidence chain, ambient threads, and placeholder register.
- [Canon Decisions & Open Questions](CANON_AND_OPEN_QUESTIONS.md) — established working canon, provisional choices, unresolved decisions, and guardrails.
- [Assignment Evidence Dependency Map](ASSIGNMENT_EVIDENCE_DEPENDENCY_MAP.md) — assignment register, core evidence paths, optional branches, knowledge gates, and recovery rules.

### Story and player-facing content
- [Opening Shift Playable Script](../story/OPENING_SHIFT_PLAYABLE_SCRIPT.md) — handover, onboarding, first NR-041 detection, registry lookup, report, and supervisor closure.
- [Main-Story Document Packet](../story/MAIN_STORY_DOCUMENT_PACKET.md) — draft incident-file documents, post-shutdown appendix, Communications Record 04-C, decoding worksheet, and follow-up correspondence.
- [Main Story Assignment Scripts](../story/MAIN_STORY_ASSIGNMENT_SCRIPTS.md) — player-facing assignment interactions and report flows for A-003 through A-006.

## Backup and change policy

1. Any substantial design, canon, chronology, evidence, assignment, or narrative work created for DEAD AIR should be committed to this repository during the same work session whenever practical.
2. Update the README and this index when adding a major project document, so the latest work remains discoverable.
3. Preserve contradictions, unresolved questions, provisional labels, and placeholders unless the project owner explicitly approves a canon change.
4. Do not start game implementation until the design is sufficiently settled and the project owner explicitly asks to begin coding.
5. Treat Git history as the change trail. Prefer new commits and explicit revisions over silently replacing project history.
6. This repository currently backs up the working Markdown documents listed above. Original binary attachments (such as DOCX files) are not claimed as repository copies unless separately committed in a supported format.

## Current implementation status

Design phase. No game code has been started. The proposed Godot 4.x approach and under-25-MB Android package target remain unvalidated.
