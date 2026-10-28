# DEAD AIR

An offline, landscape-only Android radio-conspiracy horror game about ordinary monitoring work, contradictory records, and the limits of what an institution can account for.

**Development status:** design phase. No game code should be started until the concept and design are sufficiently settled and the user explicitly asks to begin.

## Design documents

- [Game Design Overview](docs/GAME_DESIGN.md) — pillars, player role, receiver simulation, UI, time, evidence, and opening experience.
- [Master Chronology & Evidence Ledger](docs/MASTER_CHRONOLOGY_EVIDENCE_LEDGER.md) — main-story evidence, contradiction rules, optional Silent Site branch, and canon guardrails.
- [Canon Decisions & Open Questions](docs/CANON_AND_OPEN_QUESTIONS.md) — established working canon, provisional details, and decisions still to lock.
- [Opening Shift Playable Script](story/OPENING_SHIFT_PLAYABLE_SCRIPT.md) — handover, receiver onboarding, first NR-041 detection, registry conflict, report, and supervisor closure.
- [Main-Story Document Packet](story/MAIN_STORY_DOCUMENT_PACKET.md) — draft incident summary, post-shutdown appendix, Communications Record 04-C, NR-041 worksheet, and follow-up correspondence.

## Core premise

The player is a technician at Remote Monitoring Site 04, employed by the fictional National Radio Monitoring Service (NRMS, provisional). They monitor a simulated radio spectrum, record and decode transmissions, complete routine assignments, and investigate a recurring identifier: **NR-041**. That identifier conflicts with official registry records and eventually overlaps with a closed incident file concerning a government research facility.

The game must never confirm what lies beyond the connection, what it wants, or whether an experimental AI caused the incident.

## Non-negotiable design rules

- Evidence and records—not spectacle—carry the horror.
- The interface remains stable and truthful; no fake glitches or supernatural UI behavior.
- Audio adds atmosphere and information, but essential clues are always available as text.
- No essential clue can be permanently missed due to timing, tuning, recording length, or an early choice.
- Contradictory records remain contradictory; the archive never silently reconciles them.
- Administrative closure is not proof that an underlying question has been answered.
- Offline only: no accounts, online services, microphone, real SDR input, or online AI.
- Target Android package under 25 MB; Godot 4.x is a proposal, not yet validated.
