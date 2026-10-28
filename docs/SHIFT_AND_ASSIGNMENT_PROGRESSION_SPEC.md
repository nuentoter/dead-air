# DEAD AIR — Shift and Assignment Progression Specification

**Status:** Working design specification  
**Scope:** Shift structure, routine duties, assignment lifecycle, simulated time, archive requests, supervisor review, evidence discovery, and player-facing progression.  
**Implementation status:** Design only. This document does not authorize or begin coding.

## 1. Design goals

The progression system should make the player feel like a technician doing a real job inside an institution that is competent at routine administration but unable to account for its own records.

It must:

- Establish a repeatable work rhythm before gradually complicating it with evidence.
- Give the player meaningful control over what to investigate next without requiring real-world waiting.
- Keep the receiver, archive, notebook, assignments, and reports consistent with one another.
- Distinguish objective facts, system-generated summaries, the player's interpretations, and supervisor conclusions.
- Preserve all essential evidence even if a player ignores an assignment, closes the app, or discovers documents out of order.
- Avoid deadlines, punishment for exploration, or hidden time pressure.
- Keep the mystery unresolved where canon requires uncertainty.

## 2. Core progression model

Progression uses three connected layers:

1. **Shift:** the player's current work session, containing handover, routine duties, optional exploration, assignment work, and end-of-shift closure.
2. **Assignment:** a persistent work order with a stated purpose, one or more evidence paths, report fields, and a review state.
3. **Case thread:** a longer-running evidence question that may span multiple shifts and assignments, such as the recurring NR-041 identifier or the closed incident chronology.

A shift is a narrative and organizational unit, not a real-time timer. The player can stop at any point. The next time they open the game, the same unresolved work remains available.

The game should not require the player to complete every routine action before investigating a signal. Routine duties establish the workplace and provide context; they must not become repetitive gates that obstruct the main story.

## 3. Shift lifecycle

### 3.1 Shift states

A shift follows these conceptual states:

- **Handover available:** the player sees the date/shift label, a concise handover note, pending assignments, and any supervisor message.
- **Active:** receiver, archive, notebook, assignment panel, and report tools are available.
- **Work submitted:** a completed report or requested deliverable is awaiting review, or has been accepted automatically where the assignment explicitly says so.
- **Closed:** the shift summary records what was completed, what remains open, and any new messages or evidence made available.
- **Resumable:** if the app closes at any earlier point, reopening returns the player to a safe, consistent state without requiring the shift to restart.

These are design states, not a demand for a full-screen state machine. Navigation between work surfaces should remain quick and predictable.

### 3.2 Opening handover

The handover should contain only information that is useful at the start of the shift:

- Shift identifier and simulated date/time context.
- One or two routine operational notes.
- Active assignments and any review returned by Mara Venn.
- Known receiver or archive maintenance notices, if relevant.
- A brief indication of pending items, without framing them as urgent unless a later canon-approved scene specifically requires it.

Handover language should be dry, brief, and plausible. It must not tell the player what to think about a clue.

### 3.3 Active work

During an active shift, the player may move freely between:

- Receiver and signal event list.
- Recording and decoding workspace.
- Archive search and document viewer.
- Notebook, evidence links, and comparison workspace.
- Assignment details and report submission.
- Messages and supervisor review.

The player should not lose unsaved notes or stable evidence when changing screens. An in-progress report should autosave or clearly indicate its save state.

### 3.4 Closing a shift

A shift can be closed when the player chooses to do so. The game may suggest a summary when useful, but should not force closure merely because a simulated clock has advanced.

The summary records:
- Assignments submitted, accepted, returned, or still open.
- New documents or signal events retained in the archive.
- New supervisor messages.
- Unresolved work carried forward.
- Any routine tasks completed.

Do not grade the player on speed, number of receiver interactions, or how quickly they reach a story discovery.

## 4. Simulated time rules

### 4.1 What time means

Simulated time gives recordings, log entries, work orders, and shift records a coherent chronology. It is not a real-world clock and is not intended to pressure the player.

Time may advance during active play or a clearly indicated in-game queued operation. It does not advance while the app is closed or idle in the background.

### 4.2 Time advances

Time may advance when the player:
- Runs a simulated scan or receiver operation that has a defined duration.
- Starts a simulated archive retrieval with a stated duration.
- Completes a work action that explicitly records elapsed simulated time.
- Chooses to advance to the next shift.

Ordinary navigation, reading a document, opening the notebook, writing a report, or pausing should not silently consume meaningful time.

### 4.3 Queued work

If an archive retrieval or other operation takes simulated time, the UI must show:
- What was requested.
- Why it is queued.
- Its expected simulated completion point or duration.
- Whether the player can continue other work.
- What happens if the player closes the app.

A queued operation must resume or complete deterministically after reopening. It must never depend on wall-clock time. Avoid real-world waits and artificial cooldowns.

### 4.4 Chronology and time uncertainty

Do not treat all displayed timestamps as equally reliable. A record may contain a local timestamp, an archive receipt time, a system-generated index time, or a time whose clock basis is unknown. The UI should preserve the source's own terminology and uncertainty.

The main incident chronology specifically contains an official discontinuation claim at 18:00 and appendix entries at 18:17, 18:19, and 18:23, with origin and clock basis incomplete. Progression must expose this discrepancy without inventing a definitive explanation.

## 5. Assignment lifecycle

### 5.1 Assignment states

Use the following conceptual states:

- **Available:** the assignment has been issued and can be opened.
- **In progress:** the player has begun investigating or editing a report.
- **Ready to submit:** required report fields are complete.
- **Submitted:** the report is preserved and awaiting review.
- **Returned for clarification:** the supervisor requests a narrower factual statement or missing reference; this should not be used as a punitive failure state.
- **Accepted / administratively closed:** the assignment's requested work has been acknowledged.
- **Open question retained:** the work is closed administratively, but the underlying question remains unresolved.

An assignment can be accepted without the mystery being solved. Administrative acceptance must never imply that the player's hypothesis is confirmed.

### 5.2 Assignment card

Every assignment card should identify:
- Assignment ID and title.
- Issuing source or supervisor.
- A short statement of the requested task.
- Relevant known records or search locations, if already known to the player.
- Current state.
- Report or deliverable required.
- Links to associated case threads, if established.

Do not reveal evidence titles or contents before the player has a legitimate in-world reason to know them. A broad archive search may be available without pre-disclosing the exact result.

### 5.3 Report design

Reports should favor concrete, source-grounded questions:
- What did you observe?
- Which record supports that statement?
- What remains unknown?
- Is a statement a verified fact, an interpretation, or an unresolved possibility?

The player may write or select a concise conclusion, but required fields should not force one approved theory. Where free text is impractical, provide structured options plus a notes field.

A report should preserve the player's submitted wording as a historical artifact. Later revisions should be appended as a new version or addendum, not silently substituted into the original.

### 5.4 Review behavior

Mara Venn's review should be procedural, restrained, and specific. She can:
- Acknowledge receipt.
- Ask for a source citation or distinction between observation and inference.
- State that no registered-station link has been verified.
- Close the administrative request while retaining the unresolved chronology or source relationship.

She must not act as an omniscient lore dispenser. Her lack of resolution may reflect limited evidence, institutional boundaries, or an unknown cause; the story should not choose among these without canon approval.

## 6. Routine duties and their purpose

Routine duties establish the job and make the abnormal material feel embedded in ordinary work. Each should be short, skippable where appropriate, and useful to at least one of these purposes: teaching a tool, building institutional texture, maintaining a baseline, or introducing a later comparison.

Possible duty categories:

- **Receiver check:** confirm the simulated receiver is in a known configuration. This teaches tuning, mode, bandwidth, and signal history without demanding real hardware knowledge.
- **Scheduled spectrum sweep:** run a simulated scan and inspect the event list. It provides ordinary traffic as a baseline.
- **Signal classification:** label a routine event using available evidence, with uncertainty allowed.
- **Archive housekeeping:** verify metadata, check a record reference, or locate a prior shift entry.
- **Calibration comparison:** compare records from different conditions. A mismatch can be recorded without immediately being labeled anomalous.
- **Shift report:** summarize work completed and carry unresolved items forward.

Routine tasks should not require arbitrary repetition. Once a mechanic is taught, subsequent uses should be quicker and less tutorial-heavy. The player must be able to pursue story assignments without completing optional housekeeping.

## 7. Evidence and discovery rules

### 7.1 Evidence is persistent

Once the player legitimately obtains a document, recording, decode, or event entry, it remains available in the archive. Essential evidence is not consumed by reading it, attaching it to a report, or comparing it with another record.

### 7.2 Discovery paths

Essential evidence should have a primary path and at least one recovery path. Recovery can be a later archive index, a supervisor-provided reference, or a repeatable search. It should not require the player to guess an exact phrase without support.

The player may discover records out of intended order. The game should:
- Preserve the original record and its metadata.
- Update the notebook's available links when a relationship becomes supportable.
- Avoid revealing an interpretation merely because two records are both present.
- Keep the assignment available until its requested task can be completed or explicitly closed.

### 7.3 No false dependency

Do not make the player submit a particular theory to unlock a document. Do not hide a required clue behind a high score, a perfect report, an exact scan duration, or a narrow frequency tuning window.

### 7.4 Matching identifiers

The recurrence of NR-041 can justify comparison and further investigation. It does not, by itself, prove that two receptions share a transmitter, source, origin, or cause. The assignment system and notebook must retain this distinction.

### 7.5 Archive relationships

A relationship between records should be labeled according to the evidence:
- Same identifier observed.
- Similar sequence or content.
- Shared routing or receipt metadata.
- Cross-reference found in another record.
- Source relationship not established.

Never automatically convert a similarity into a verified common origin.

## 8. Main-story progression: current intended sequence

This is a progression guide, not a rigid unlock chain. The player may discover records out of order, but the assignment prompts should support a gradual shift from routine work to contradictory institutional records.

### Stage 1 — Orientation and baseline
- Opening shift handover.
- Receiver controls and ordinary signal traffic.
- First NR-041 detection.
- Registry lookup finds no station record for NR-041.
- Player records a factual report; Mara acknowledges it without resolving the identifier.

The first shift should teach the work loop, not explain the larger incident.

### Stage 2 — Recurrence
- A later reception again carries NR-041 under different conditions.
- A-003 asks the player to compare the receptions.
- The report distinguishes repeated identifier from verified common source.
- The case thread becomes active and remains open.

### Stage 3 — Closed incident reference
- A-004 asks the player to locate a referenced closed incident file.
- M-07 says operations were discontinued at 18:00 and equipment secured.
- M-08 preserves entries at 18:17, 18:19, and 18:23.
- The appendix does not establish a reliable origin or clock basis.

The player should be able to state the contradiction without claiming to know why it exists.

### Stage 4 — Communications Record 04-C
- A-005 directs a separate archive search for Communications Record 04-C.
- M-09 contains a sequence and routing/receipt information that can be compared with the appendix.
- The origin remains unknown; the record does not prove an independent original transmission.
- The player can link the records as a comparison, not as a settled source attribution.

### Stage 5 — Chronology review
- A-006 asks for a factual chronology and an assessment of the relationship between the records.
- The report distinguishes documented times from assumptions about clock basis and source.
- Mara closes the requested review with the administrative finding that no verified registered-station link has been established.
- The chronology and record relationship remain unresolved; the originals are retained.

### Stage 6 — Further investigation
Later assignments may introduce personnel indexes, AI evaluation material, independent chronology review, or cross-station calibration comparisons. These are candidate threads, not confirmed mandatory canon. Their content, order, and relationship to the incident remain subject to approval in the canon/open-questions document.

## 9. Optional Silent Site branch

The Silent Site branch should be optional and should not block the main incident investigation.

Current established evidence chain:
- A neighboring monitoring station retained an incomplete recording containing ordinary traffic and an unexplained element.
- A routine transfer receipt records a package from the Silent Site but identifies only its administrative destination.
- A regional operations index confirms receipt of a package; contents are unverified and receiving initials are illegible.
- No surviving inventory lists the missing operational logs.
- There is no established proof of deliberate destruction, and no confirmed connection to the main incident.

Progression rules:
- The branch can be entered through ordinary archive work or a relevant assignment lead.
- Each document should be recoverable once its lead is known.
- The branch may end with the package's administrative trail established but its contents and the logs' ultimate fate unresolved.
- Do not make the branch a secret explanation for NR-041 or the research incident.

## 10. Notebook and case-thread behavior

The notebook is a player-authored reasoning aid, not an authority that decides what is true.

It should support:
- Notes attached to a source.
- Links between documents and signal events.
- A distinction between confirmed fact, working hypothesis, and open question.
- Comparison views for timestamps, identifiers, sequence fragments, routing, and receipt metadata.
- A short provenance trail showing where a claim came from.

Suggested case-thread states:
- **Unopened lead:** the player has not yet encountered the issue.
- **Active investigation:** at least one relevant item has been discovered.
- **Evidence accumulating:** multiple items can be compared.
- **Review requested:** a report has been submitted.
- **Administratively closed / unresolved:** requested work is complete but the central question remains open.

Do not automatically write conclusions in the player's voice. Suggested links may be offered, but the player should be able to decide whether to create a note or claim.

## 11. Save, pause, and interruption behavior

- Save after material evidence acquisition, report edits, submissions, archive retrieval completion, and assignment-state changes.
- Preserve the current screen or return to a safe work overview after reopening.
- Pause simulated operations when the app is closed; resume deterministically when reopened.
- Never expire an assignment because the player did not open the game.
- Never penalize the player for reading slowly, taking notes, or leaving mid-shift.
- If an operation was in progress at interruption, explain whether it is paused, complete, or ready to resume. Do not fabricate a failed result.
- Keep originals immutable. Corrections and new metadata are added as explicit versions or annotations.

## 12. Player feedback and tone

Feedback should be quiet, practical, and legible:
- “Record added to archive.”
- “Report submitted for review.”
- “Reference found; source relationship not established.”
- “Review closed. Chronology remains unresolved.”
- “No registered station record found for NR-041.”

Avoid dramatic success banners, failure sounds, urgency timers, or ominous interface animations. Any unsettling effect should come from the contents of a stable record, not from the interface pretending to malfunction.

## 13. Accessibility and usability requirements

- All essential audio information has a readable text equivalent.
- Text, timestamps, and metadata can be revisited without replaying a recording.
- Controls remain usable in landscape orientation on a small Android screen.
- Report drafts and notes persist through navigation and app interruption.
- Avoid relying on color alone to distinguish evidence status or confidence.
- Clearly distinguish the source's own wording from interface annotations.
- Provide a way to inspect full metadata without forcing it into every compact list row.

## 14. Open decisions

The following should remain open until deliberately decided:
- Exact shift count and total campaign length.
- Whether shifts advance automatically after a report or only by player choice.
- How much routine work is mandatory in the opening tutorial.
- Exact archive retrieval durations and whether any should be queued at all.
- Final assignment IDs, beyond the established A-003 to A-006 sequence.
- Exact calendar dates, receiver frequencies, and signal timestamps where current scripts still use placeholders.
- The scope and order of any later personnel, AI evaluation, independent review, and calibration assignments.
- Whether any branch endings affect later dialogue; they must not remove essential evidence.

## 15. Acceptance criteria for future implementation

The progression design is ready to implement only when a prototype can demonstrate all of the following:

1. A player can leave and resume at any point without losing evidence or report work.
2. Simulated time never advances while the app is closed or idle in the background.
3. A player can perform routine work, investigate an assignment, and return to the receiver without losing context.
4. Assignments can be submitted, reviewed, returned for clarification, and administratively closed without equating closure with truth.
5. The player can discover core documents out of order and still complete the intended reports.
6. Essential evidence has recovery paths and cannot be permanently missed.
7. The NR-041 recurrence is never automatically treated as proof of a shared source.
8. The 18:00 discontinuation claim and 18:17 / 18:19 / 18:23 appendix entries remain contradictory, with clock basis and origin unresolved.
9. Communications Record 04-C can be compared with the appendix without the game asserting an independent original or common source.
10. The Silent Site branch remains optional and does not become an unapproved explanation for the main incident.
11. The interface remains stable and truthful, with no fake glitches or real-world deadlines.
12. The main story remains compatible with the project's core uncertainty: the game does not confirm what lies beyond the connection, its intentions, or whether experimental AI caused the incident.

---

## Summary of design intent

DEAD AIR progression should feel like work accumulating in an archive, not a puzzle clock counting down. The player chooses what to examine and when to stop. Evidence persists, reports preserve uncertainty, supervisors close administrative tasks rather than cosmic questions, and the institution's records remain the primary source of dread.
