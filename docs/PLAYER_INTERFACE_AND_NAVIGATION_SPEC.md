# DEAD AIR — Player Interface and Navigation Specification

**Status:** Working design specification.  
**Scope:** Landscape Android layout, primary navigation, receiver, recordings, archive, notebook, assignments, reports, and messages.  
**Implementation:** Contract for the active Godot prototype. The first pass is script-built and subject to verification against the acceptance criteria.

## 1. Purpose

The interface is a compact monitoring workstation, not a collection of unrelated menus or a cinematic horror interface. It should support a clear workflow: observe a signal, preserve it, inspect it, compare it with records, document findings, and submit a report.

## 2. Non-negotiable principles

- Stable and truthful: no fake glitches, deceptive controls, false warnings, or supernatural UI behavior.
- Evidence-first: important claims link to a signal event, recording, transcript, document, or report.
- Readable on a landscape Android phone, with reliable touch targets.
- Consistent identifiers and terminology across every screen.
- Fast navigation that preserves the player's place and unsaved work.
- Progressive detail: compact lists first, full metadata in detail views.
- No essential information hidden behind color, animation, tiny visual differences, or perfect timing.
- Offline and self-contained: no account, online service, microphone, real SDR input, or online AI.

## 3. Global layout

### 3.1 Top status strip

Display the DEAD AIR / Remote Monitoring Site 04 identity, current shift label and simulated-time context, unsaved-work or operation status when relevant, and a restrained indicator for new messages or reviews.

Do not add a horror meter, threat level, hidden sanity score, or countdown.

### 3.2 Primary navigation

Provide persistent direct access to six primary areas:

1. Receiver
2. Recordings
3. Archive
4. Notebook
5. Assignments
6. Messages

The selected area must be indicated by text and shape as well as color. On narrow screens, labels may be compact, but icon-only navigation must not be the sole way to identify destinations.

### 3.3 Main work area

Use a focused work panel. List/detail layouts are appropriate, with an optional collapsible metadata panel. Do not force three narrow columns onto small screens. The player should be able to switch between a list and detail view while retaining context.

When relevant, show a small context label for the current signal, recording, document, assignment, or report draft. It must not obscure controls or content.

## 4. Navigation rules

- The player can switch between primary sections at any time.
- Opening an item from any cross-link must open the same canonical record.
- Back returns from detail to list, then to the prior section where appropriate.
- Back must not discard notes or reports without a clear warning and explicit confirmation.
- Reading a record does not consume it.
- Cross-links should connect signal events to recordings and decodes; recordings to transcripts and archive items; documents to related assignments; notebook claims to their sources; assignments to reports; and supervisor messages to the relevant report.
- Use “compare with” or “related record” where appropriate. A link must not imply proven causation.
- Search should tolerate partial IDs and ordinary words. Filters may include type, shift/date, identifier, status, and known source.
- A no-results message describes the index searched; it does not prove a record never existed.

## 5. Receiver workspace

The receiver follows the dedicated Receiver Interaction & Signal Behavior Specification. Group controls by purpose:

- Tuning: frequency, band, tuning step, and direct adjustment.
- Mode and bandwidth: current mode and selected bandwidth.
- Signal display: waterfall and current reception information.
- Operation: SEEK/scan, stop, record, and decode when applicable.
- Reception status: signal strength/quality, noise-reduction state, and event-retention status.
- Event list: recent and retained events that can be selected without erasing the live receiver state.

The waterfall uses frequency horizontally and time vertically. It is a functional data display, not a hidden-image device or decorative horror animation. Its colors and contrast must remain legible and cannot be the sole means of communicating status.

Controls show their current values. Changing one setting must not silently change unrelated settings. The live receiver state and retained event history are distinct; leaving the receiver does not delete events. Returning should restore the prior tuning and display state unless the player changes it or an authored handover establishes a new configuration.

## 6. Recordings workspace

The recordings list should show a stable event/recording ID, simulated date/time or range, frequency and mode, decoded identifier when supported, and recording/decode status.

A detail view may include simulated playback, transcript or decode output, reception metadata, confidence and limitations, notes, provenance, and links to source events, archive items, and assignments.

The player may pause, replay, mute, or inspect text without penalty. Essential story content remains readable without audio. Clearly distinguish original reception metadata, a decode derived from it, player annotations, and later archive cross-references. Interpretations never overwrite original signal data.

## 7. Archive workspace

The archive is an administrative record system, not an answer engine.

### Search view

Provide search terms or a document ID, optional category/date filters, visible search status, and results showing ID, title, date when known, and source/collection. A queued search must explain what is being searched and whether other work can continue. There is no real-world waiting.

### Document view

Show original title and ID, source/collection when known, date/time fields exactly as recorded, full document text, and an expandable provenance/metadata area. Later annotations and correction history must be visibly separate from the original.

Do not normalize conflicting dates or silently rewrite an original. Useful literal states include:
- “No matching record found in this index.”
- “Reference located; document unavailable in this collection.”
- “Receipt recorded; contents not verified.”
- “Timestamp basis not stated.”

A missing record is a statement about current archive contents, not proof of destruction or concealment.

## 8. Notebook and comparisons

The notebook supports player-authored notes, evidence links, comparisons, and open questions. A note may have a title, body, creation shift/time, linked sources, and an optional label such as observation, hypothesis, or open question.

Comparison views can align identifiers, sequence/content fragments, frequency/mode, timestamp and clock basis, routing/receipt metadata, and source/collection. Show literal differences without automatically issuing a verdict. Similarity does not establish common origin.

The notebook is a reasoning aid, not an authority that decides what is true. Do not automatically write conclusions in the player's voice.

For the main incident, preserve the official 18:00 discontinuation claim and appendix entries at 18:17, 18:19, and 18:23 as a discrepancy. Origin and clock basis remain unresolved.

## 9. Assignments and reports

The assignment list distinguishes available, in-progress, submitted, returned, accepted, and administratively closed work.

Each assignment detail should show ID/title, issuer, task, state, review notes, relevant records already known to the player, required deliverable, and report history. It guides the task without giving away an undiscovered conclusion.

The report editor should support findings, source references, uncertainty/limitations, and assessment or next action. Keep input practical on a phone keyboard, provide a clear save state, and preserve drafts.

Before submission, show a review summary of the report and linked sources. After submission:
- Preserve the exact submitted version.
- Display submission state and simulated-time context.
- Store later clarifications as new versions or addenda.
- Show supervisor response as a separate review/message record.

A submitted report must never be silently rewritten.

## 10. Messages and supervisor review

Messages contain handovers, routine notices, assignment returns, and Mara Venn's reviews. Display sender, subject, date/shift context, and links to related work. A supervisor response is itself a record; it does not automatically prove the underlying claim.

Keep tone professional and restrained. Do not use ominous typing effects, sudden text changes, or animations that imply the interface is malfunctioning.

## 11. Identity, provenance, and status

Persistent objects need stable IDs and types. At minimum distinguish signal event, recording, decode/transcript, archive document, notebook note, assignment, report version, and message/review.

Provenance must distinguish source data from interface annotation and player interpretation. If an item is unavailable, show that state instead of opening an unrelated substitute.

Notifications should be informational: new assignment, retrieval complete, report received/returned, new supervisor message, or new evidence retained. Avoid flashing warnings, unexplained colors, alarming sounds, and hidden danger meters. Color is supplementary; every status also needs text or a clearly labeled icon.

## 12. Audio, accessibility, and small screens

Audio controls include play/pause, replay, and mute as relevant. Volume does not alter decode data or metadata. Uncertain transcript portions are labeled honestly; do not fabricate speech to fill gaps or imply a reconstruction is verbatim.

- Design for landscape orientation and touch.
- Keep primary controls large enough for reliable tapping.
- Use readable text and strong contrast.
- Never rely on color alone for status, confidence, or selection.
- Preserve focus and selection when navigating back.
- Keep essential information out of transient toasts only.
- Make destructive-action confirmations explicit.
- Allow records and transcripts to be revisited.
- Avoid rapid flashes, aggressive shake effects, or animations that interfere with reading.
- Visually distinguish source text, interface annotations, and player notes.

## 13. Visual direction and primary screen

The visual style should suggest a modest institutional workstation: restrained typography, compact metadata, clear panel boundaries, neutral or dark surfaces, and a limited accent palette. Exact colors, typefaces, and icons remain open until device testing.

The initial receiver screen should prioritize the instrument:
- Top: site identity, shift/time, messages indicator.
- Left edge or compact strip: persistent navigation.
- Main upper area: frequency/mode controls and reception summary.
- Main central area: waterfall.
- Lower or side area: operation controls and recent events.
- Optional context panel: selected event details.

This is a hierarchy, not a fixed pixel mockup. Device testing must determine exact placement. Do not sacrifice touch targets or legibility to preserve a desktop-style multi-pane layout.

No fake scanline distortion, random flicker, glitch overlays, or horror effects that could be mistaken for software failure.

## 14. Empty states and errors

Empty states should explain the next available action without implying a story conclusion. Examples:
- “No retained event selected.”
- “No recordings match these filters.”
- “No matching record found in this index.”
- “No notes yet. Add a note from a record or create one here.”
- “No active assignments. Check messages or review closed work.”
- “Draft saved locally.”
- “Report submitted for review.”

Errors should be honest and actionable. If an operation or save cannot complete, explain what remains safe and what the player can do. The goal is to prevent data loss, not dramatize it.

## 15. Open decisions

Remain undecided until deliberately resolved:
- Exact navigation placement and whether it uses icon-plus-label tabs or compact text tabs.
- Supported screen sizes and responsive breakpoints.
- Final colors, typography, panel treatment, and icon family.
- Whether the event list is docked beside the waterfall or collapsible.
- Whether archive search gains an optional global mode.
- Exact ID conventions for each object type.
- Report input method and use of predefined choices.
- Whether notebook tags supplement notes and links.
- Any export feature beyond the current no-export-to-file direction.
- Exact audio-player layout and transcript alignment.

## 16. Acceptance criteria

A UI prototype must demonstrate:
1. All six primary areas are reachable without losing unsaved work.
2. The same record opens consistently from all cross-links.
3. Receiver tuning, mode, waterfall, and event retention have clear states.
4. Recordings and transcripts are inspectable without audio playback.
5. Archive search distinguishes no result from unavailable or unverified records.
6. Original text and metadata are separate from annotations.
7. Comparisons show similarities/differences without unsupported causal claims.
8. Report drafts survive navigation and app interruption.
9. Submitted reports remain immutable; later changes use addenda or versions.
10. Status and confidence are not conveyed by color alone.
11. There are no fake glitches, countdowns, horror meters, or deceptive controls.
12. The app is usable on a landscape Android phone without illegible text or desktop-sized assumptions.
13. Essential evidence can always be revisited and is never audio-only.
14. The main incident's source and chronology remain unresolved where canon says they are unresolved.

---

## Summary

Receiver, recordings, archive, notebook, assignments, and messages are different views into one consistent record system. The player moves freely between them; provenance is preserved; reports remain historical artifacts; and the interface never pretends to know more than the records establish.
