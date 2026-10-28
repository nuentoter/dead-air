# DEAD AIR — Prioritized Design Decision Register

**Status:** Active working register  
**Purpose:** Identify which decisions block the next stage, which can be deferred, and which are guardrails rather than choices.  
**Implementation status:** Design only. This register does not authorize coding.

## How to use this register

- **P0 — Before implementation planning:** Resolve or explicitly accept a bounded provisional decision before the project can be called implementation-ready.
- **P1 — Before the affected content is finalized:** Decide before the relevant story scripts, receiver behavior, or interface contract is frozen.
- **P2 — Prototype / production validation:** Can remain open until a small test or measurement provides better evidence.
- **Guardrail:** Not an open creative choice; must be preserved unless the project owner explicitly changes it.
- **Status:** Open, provisional, partly specified, or locked working rule. “Provisional” is not canon.

Do not settle a decision merely to fill a checklist. When evidence is insufficient, keep the question open and record what test or information would resolve it.

## 1. P0 — Resolve before implementation is authorized

| ID | Decision | Current position | What must be decided | Dependency / exit condition |
|---|---|---|---|---|
| D-001 | Canonical institutional names | NRMS, Remote Monitoring Site 04, Mara Venn, Regional Operations, and Regional Technical Review Office are working canon v0.2 | Keep for the current release design or explicitly rename; maintain the distinction between the two offices | Update every design/story document and record template consistently |
| D-002 | Canonical identifiers and numeric sequence | `NR-041`, `01-773`, `04-C`, sequence `731904`, and Signal IDs `SIG-0001`–`SIG-0005` are working canon v0.2 | Finish propagation/audit; preserve lower sequence confidence and unknown meaning | Evidence ledger, document packet, receiver events, assignments, and notebook examples agree |
| D-003 | Date/time and frequency register | ISO dates/24-hour display, `10.000 MHz AM` time standard, and `7.418 MHz CW` NR-041 frequency are working conventions; calendar dates and external clock basis remain open | Complete the event calendar and verify every artifact against the canonical register | Every authored record matches the register or explicitly marks its value as unknown/placeholder |
| D-004 | Main-story evidence chain | Core chain is drafted through A-006; later materials are candidates | Confirm which documents and assignments are mandatory, optional, or merely outlined | Dependency map identifies a recoverable path to every essential finding |
| D-005 | Opening-to-midgame scope | Opening and A-003 to A-006 have scripts; total campaign length is open | Choose a bounded campaign scope: minimum core shifts/assignments and what counts as a complete first release | A complete beginning, middle, and ending scope exists without requiring every optional branch |
| D-006 | Ending structure | Ending branches and conditions are not locked | Decide how many endings exist, what player actions may affect them, and which facts remain unresolved in all endings | Ending outlines obey the uncertainty guardrails and do not hide essential evidence behind a branch |
| D-007 | Implementation start gate | Design-first policy; no code has been authorized | Explicitly decide when design is sufficiently settled and authorize coding separately | No implementation begins from an inferred “go ahead” to design work alone |

## 2. P1 — Resolve before the relevant content is frozen

| ID | Decision | Current position | What must be decided | Dependency / exit condition |
|---|---|---|---|---|
| D-008 | Government facility and project naming | Intentionally unspecified in some records | Keep anonymous or choose a consistent name and institutional description | All records use the same level of specificity; no name accidentally explains the phenomenon |
| D-009 | Receiver capture model | Receiver spec defines retained events and recording behavior at a design level; final buffer policy remains open | Define rolling-buffer length, manual recording, event retention, automatic capture, and what is saved by default | Receiver event, recording, transcript, and archive provenance remain distinct and recoverable |
| D-010 | Simulated time and scan durations | Progression rules prohibit wall-clock pressure; exact durations remain open | Decide which actions consume simulated time, whether scans have durations, and whether archive retrieval is ever queued | Time behavior is deterministic, visible, pause-safe, and testable |
| D-011 | Routine work volume | Routine duties are established as short and skippable where appropriate | Decide which duties appear in the opening tutorial and which recur later | Routine work teaches systems without becoming a grind or blocking story investigation |
| D-012 | Assignment register and release scope | A-003 through A-006 are established working scripts; later assignments are candidates | Label each assignment core, optional, or deferred and define prerequisites plus recovery paths | No essential evidence depends on an optional assignment |
| D-013 | Silent Site branch scope | Optional branch; package receipt trail established, ultimate log fate unresolved | Decide the minimum playable evidence chain and whether it has a separate branch closure | It remains optional and does not become an unapproved explanation for NR-041 or the main incident |
| D-014 | Report interaction model | Structured fields and free text are both under consideration | Choose report fields, editable text behavior, source linking, submission confirmation, and addendum flow | Reports are usable on a phone, preserve exact submitted versions, and accept uncertainty |
| D-015 | Persistent object ID scheme | Stable object identities required; complete format not set | Define formats for events, recordings, decodes, documents, notes, assignments, report versions, and messages | Cross-links resolve consistently and no item gets conflicting aliases |
| D-016 | Notebook organization | Notes, evidence links, comparisons, and open questions proposed | Decide whether tags, pinned items, and explicit claim-to-source links are needed for first release | Notebook remains a reasoning aid, not an automatic truth engine |
| D-017 | Audio presentation | Audio is simulated and text equivalents are mandatory | Decide sound palette, transcript presentation, replay behavior, and whether any voice is used | Meaningful content never depends on hearing, and audio scope fits the size target |
| D-018 | Visual system | Neutral/dark institutional workstation proposed | Choose type scale, contrast, accent palette, navigation placement, and receiver panel layout after screen testing | Landscape UI prototype passes readability and touch-target checks on intended devices |
| D-019 | Save model | Autosave at material events and drafts proposed | Define save slots or single profile, persistence format, and handling of interrupted operations | Restart tests show no lost evidence, submitted reports, or in-progress notes |
| D-020 | Global archive search | Contextual search is specified; global search is optional | Decide whether first release needs cross-type search | If present, results label type, ID, source, and confidence; if absent, local search remains sufficient |
| D-021 | Facility/operator life details | Operators' lives exist as background texture; the player is anonymous to them | Decide how much ambient traffic and operator characterization is needed for the first release | Human detail supports atmosphere without introducing relationship meters or a separate social simulation |

## 3. P2 — Validate with a prototype or measurement

| ID | Decision / test | Current position | Evidence required | Exit condition |
|---|---|---|---|---|
| D-022 | Engine choice | Godot 4.x/GDScript proposed, not validated | Build a tiny landscape Android test with navigation, text, and a simple receiver visualization | Engine/export workflow is stable on the target device class |
| D-023 | Package-size target | Under 25 MB is a target, not a verified result | Measure a clean release export with actual fonts, audio, and assets | Record actual size; reduce scope or revise target only with explicit approval |
| D-024 | Waterfall readability | Behavior is specified conceptually | Test frequency/time orientation, density, contrast, and touch selection on a phone | Player can interpret signal activity without color-only cues or tiny targets |
| D-025 | Receiver interaction complexity | Bands, modes, tuning, SEEK, and simplified processing are specified at a high level | Test direct tuning versus simplified controls with a short onboarding | It feels like a receiver without requiring real radio expertise or excessive taps |
| D-026 | Audio footprint and usefulness | Audio is optional for core comprehension | Measure representative generated audio and compare atmosphere/information value | Audio fits package constraints and contributes without becoming a clue gate |
| D-027 | Touch target and text scale | Landscape-first requirement established | Test on the smallest intended display and with Android system text/accessibility settings | No essential control or document text becomes impractical |
| D-028 | Save reliability | Persistence behavior specified conceptually | Test forced close, background/foreground, device restart, and interrupted queued operation | No evidence or submitted report is lost; time does not progress while closed |
| D-029 | Production cost and price | USD $0.99 is only a possibility | Decide after scope, store requirements, and release costs are better understood | Price is explicitly approved or removed as a planning assumption |

## 4. Guardrails — Not open decisions

These rules are considered active working constraints, not questions to solve during routine design.

1. **No premature coding.** Design work, a plan, or a “do it” referring to a design task is not authorization to start implementation. Coding requires explicit approval to begin.
2. **The main phenomenon remains unknown.** Do not confirm what lies beyond the connection, its intentions, or whether experimental AI caused the incident.
3. **Contradictions stay visible.** The official 18:00 discontinuation claim and appendix entries at 18:17, 18:19, and 18:23 remain in conflict; origin and clock basis are unresolved. M-09's 18:19, 18:21, and 18:23 rows match in the packet and assignment script.
4. **No unsupported source attribution.** Matching NR-041 identifiers, sequences, or routing details do not alone prove a common transmitter, independent original, entity, or cause.
5. **Silent Site stays optional and unresolved.** Its package trail does not prove deliberate destruction or a link to the main incident.
6. **No fake interface malfunction.** No supernatural UI glitches, false alerts, hidden danger meter, or interface deception.
7. **Evidence is recoverable.** No essential clue can be permanently missed due to timing, tuning, recording duration, a missed transmission, a branch choice, or a report grade.
8. **No real-world pressure.** No real-time deadlines, expiring assignments, streaks, or penalties for closing the app.
9. **Audio is never the only path.** All meaningful content has a readable text equivalent.
10. **Records are immutable history.** Corrections and clarifications are new versions or annotations, not silent rewrites.
11. **Administrative closure is not truth.** A report can be accepted while its central question remains unresolved.
12. **No online dependencies.** No online AI, accounts, microphone, real SDR input, or online services.

## 5. Recommended decision order

To avoid rework, resolve decisions in this order:

1. **Story consistency:** D-001 to D-004. Working names/IDs are adopted for this pass; calendar dates, external clock basis, and evidence-chain status still need review.
2. **Release scope:** D-005 to D-007 and D-012. Define what the first complete game contains and what constitutes an ending before implementation is authorized.
3. **Player interaction contract:** D-009 to D-021, using the receiver, progression, and interface specifications as the starting point.
4. **Narrative completion:** D-008, D-013, D-017, and D-021 as needed to finish the core and optional content.
5. **Prototype validation:** D-022 to D-028. Use measured results rather than guesses.
6. **Commercial decision:** D-029 only when the scope and costs are understood.

This order is a recommendation, not an automatic commitment. Decisions can be reordered if a dependency requires it, but record the reason.

## 6. Definition of design-ready

DEAD AIR is not ready for implementation solely because every row is marked complete. Before coding is authorized, all of the following must be true:

- The first-release scope and a complete playable narrative arc are defined.
- All essential assignments and evidence have dependency/recovery paths.
- Canonical IDs, timestamps, frequencies, and unresolved clock-basis labels are consistent.
- Receiver, progression, interface, archive, and report rules do not contradict one another.
- The ending structure preserves the core uncertainty.
- Technical risks and unvalidated targets are listed honestly.
- The project owner explicitly authorizes the start of implementation in a separate instruction.

A decision may remain provisional if it is isolated, reversible, and does not block a stable interface or narrative contract. Record such exceptions instead of pretending the choice is final.

## 7. Change control

When a decision is made:
1. Update the status and rationale in this register.
2. Update the owning specification or canon document.
3. Check linked scripts, records, IDs, and dependency maps for consistency.
4. Commit all related edits together when practical.
5. Keep unresolved questions unresolved unless the project owner decides them.

Do not use this register to silently change story canon. It is a map of decisions and dependencies, not a substitute for the source documents.
