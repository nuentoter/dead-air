# DEAD AIR — Main Story Assignment Scripts

*Working narrative/UI specification, version 0.1. This is not game code. It continues the Opening Shift Playable Script and follows the Main-Story Document Packet and Assignment & Evidence Dependency Map. Exact dates, frequencies, Signal IDs, and the numeric sequence remain placeholders.*

## Script principles

- Keep the interface professional, restrained, and legible.
- Let ordinary workflow language precede interpretation.
- Documents do not announce their own horror or tell the player what to conclude.
- Critical documents remain recoverable if their first discovery route is missed.
- Discovery may happen out of order. Preserve what the player found and update assignments naturally.
- Report wording can differ, but reasonable choices cannot block the critical path.
- Show timestamps as printed. Never silently normalize them or assume a shared clock.
- Original records remain immutable; later comparisons are linked records.

# A-003 — Compare recurring identifier

**Status:** Core. **Purpose:** Establish recurrence under different reception conditions without proving a shared transmitter.

## Assignment card

**Title:** Compare recurring identifier  
**Category:** Receiver / signal verification  
**Priority:** Routine follow-up  
**Status:** OPEN

> A reception matching the previously reported identifier has been retained for comparison.
>
> Compare the identifier and available reception details with the earlier NR-041 report. Record what is consistent and what differs. Do not infer a common source from the identifier alone.

**Actions:** Open retained event; compare with previous reception; view transcript; open linked report; add notebook observation; submit comparison.

## Retained event panel

- Signal ID: SIG-[GLOBAL ID PLACEHOLDER]
- Mode: CW
- Frequency: [FREQUENCY PLACEHOLDER]
- Reception time: [TIME PLACEHOLDER]
- Classification: IDENTIFIER — provisional
- Decoded identifier: NR-041
- Reception quality: weaker / fading relative to the first retained event
- Decode confidence: high for identifier; sequence confidence may be lower
- Provenance: retained monitoring event

**Transcript**

> NR-041  
> [SEQUENCE FIELD — CANONICAL NUMERIC SEQUENCE TBD]

**Panel note**

> The retained transcript represents the best available decode of this event. Reception quality differs from the earlier event. The event metadata has not been changed to match the earlier reception.

If missed live, add:

> This event was retained by the monitoring system. It was not manually recorded during your active receiver session.

## Comparison screen

| Field | Earlier event | Recurrence |
|---|---|---|
| Identifier | NR-041 | NR-041 |
| Mode | CW | CW |
| Frequency | [pending] | [pending] |
| Reception time | [pending] | [pending] |
| Signal quality | [earlier reading] | Weaker / fading |
| Pattern / timing | [first pattern summary] | Different pattern/timing |
| Sequence decode | [canonical value TBD] | [canonical value TBD] |
| Source | Not established | Not established |

**System note**

> Matching identifiers and similar decoded content support a comparison. They do not independently establish that both receptions came from the same physical transmitter.

## Player comparison options

**A — Minimal**

> Both events decode as NR-041. The second reception differs in pattern or timing and has weaker reception quality. Source not established.

**B — Detailed**

> The identifier decodes consistently across both retained events. Reception conditions and transmission pattern differ. The sequence field appears comparable, subject to the stated decode confidence. No transmitter identity or common origin is established.

**C — Hold as a private note**

Save the comparison in the notebook. The assignment remains open. A-004 may become available once the player has viewed the event and transcript; report submission is not a hard gate.

If the player asserts a common transmitter, show:

> This is a hypothesis rather than a verified field. You can retain it as an interpretation, or revise the report to distinguish observation from inference.

No penalty or lockout follows.

## Completion response

On submission, save the comparison as a new report linked to both event records and the original report. Do not alter the original transcript, recording, or first report.

**System message**

> Comparison saved. The new report is linked to both retained events. Original reception metadata remains unchanged.

**Mara Venn**

> Thank you. The recurrence is relevant to the record, but the identifier alone still does not establish an origin station.
>
> Keep the two receptions separate in the archive. If a sequence or reference appears in another retained record, cite that record and distinguish the match from any conclusion about source.

**Status:** CLOSED — COMPARISON RETAINED  
**Unlock:** A-004, Locate incident-file reference.

## Recovery and out-of-order rules

- If the player opens the recurrence before A-003 is offered, mark it discovered and prefill the assignment.
- If the player skips comparison, A-004 becomes available after the event and transcript are viewed. A-003 can be completed later.
- If sequence decoding is incomplete, preserve the high-confidence identifier and allow replay/worksheet comparison later. Do not invent a sequence.
- If incident file 01-773 is found first, preserve it and offer a notebook prompt to compare its sequence reference with the NR-041 events.

# A-004 — Locate incident-file reference

**Status:** Core. **Purpose:** Present the official discontinuation account and later appendix entries as records that cannot be reconciled at face value.

## Assignment card

**Title:** Locate incident-file reference  
**Category:** Records / technical archive  
**Priority:** Routine records follow-up  
**Status:** OPEN

> A sequence reference from the Site 04 decoding worksheet may appear in retained technical records.
>
> Search the incident index and technical enclosures for a matching reference. Record document IDs and timestamps as printed. Do not correct a timestamp without a source record supporting the correction.

Suggested search terms: [canonical sequence TBD], 01-773, communications worksheet, enclosure C-4, operations discontinuation. These are not exact-syntax requirements.

## Search result: incident file

> **01-773 — Research Facility Operations Discontinuation**  
> Record type: Internal technical incident  
> Status: CLOSED  
> Archive status: Retained  
> Index note: Technical appendices are stored in a separate enclosure. Ingestion order may not match authoring order.

Open the file cover sheet M-06A. Keep this note visible:

> The file is considered administratively complete. Completeness indicates that required document categories were received or marked not applicable; it does not certify that every referenced communication or source record survives in this archive.

Actions: Open operations summary; browse technical enclosure; save to notebook; compare references; return to search.

## M-07 — Operations Discontinuation Summary

Display the document as ordinary administrative paperwork.

**Key fields**
- Event time referenced: 18:00, [DATE TBD]
- Received by Regional Technical Review: 18:26, [DATE TBD]
- Equipment: reported secured
- Operational exception: none attached
- Signature image: unavailable in this copy

**Records note**

> This summary records the responsible unit's submitted status. It is not an independent inventory of every device, communication path, or retained medium.

**Player prompt:** What does this record establish?

- **A.** The official summary says operations were discontinued at 18:00 and equipment was reported secured.
- **B.** All equipment and communication systems were certainly inactive after 18:00.
- **C.** The summary is false.

Feedback for A:

> Supported. The document establishes what the responsible unit reported. It does not independently verify every system's state after that time.

Feedback for B:

> The document does not inventory every device or communication path. Keep the distinction between a submitted status and independently verified activity.

Feedback for C:

> The available records do not establish that the summary is false. Record the claim and compare it with other evidence.

No answer is a game-over failure.

## M-08 — Technical Appendix: Communications Activity

The appendix is stored in a separate enclosure with its own metadata. Preserve incomplete fields.

| Logged time | Route | Entry | Status |
|---|---|---|---|
| 18:17 | Internal route [origin incomplete] to coordination channel | Sequence received; checksum blank | RECEIVED |
| 18:19 | Coordination channel to internal relay | Repeat of sequence worksheet C-4 | ROUTED |
| 18:23 | Internal relay to [destination incomplete] | Acknowledgement recorded | ACKNOWLEDGED |

**Technical Records comment**

> The entries were transcribed from the communications worksheet provided with the appendix. The source worksheet does not include a complete origin identifier. The time basis is listed as “local”; the source does not define whether this refers to the facility clock, relay clock, or receiving-office clock.

**Handling note**

> The appendix has been retained as supplied. Its association with the discontinuation summary should not be treated as confirmation that every entry occurred before or after the discontinuation event.

## Comparison prompt

After both M-07 and M-08 are opened, show a quiet notebook prompt:

> The summary references discontinuation at 18:00. The appendix contains entries at 18:17, 18:19, and 18:23. The records use an incompletely defined local time basis, and the appendix's origin fields are incomplete.

**A — Factual**

> The official summary states that operations were discontinued at 18:00. The appendix contains later-timestamped communications entries. The available records do not establish a common clock basis or explain the difference.

**B — Hypothesis**

> Communications may have continued after operations were discontinued, but the current records do not rule out a delayed, misdated, or misattributed entry.

**C — No conclusion yet**

> Preserve both documents and leave the chronology unresolved pending an independent record.

All three choices preserve progression. Option B is stored as a hypothesis, not a verified fact.

## Completion response

**System message**

> Comparison saved. The summary and appendix remain separate archive records. No timestamp or source field has been corrected.

**Status:** IN PROGRESS — RELATED COMMUNICATIONS RECORD NOT YET CHECKED  
**Next suggested action:** Search communications archive for worksheet C-4 or the same sequence reference.

Unlock A-005, but do not block other archive exploration.

## Recovery and out-of-order rules

- If M-08 is found before M-07, retain it and offer the summary as a related search result.
- If M-07 is found first, the appendix remains available through the enclosure reference and broad search.
- Searching only 01-773 shows the cover and a technical-enclosure link.
- Searching by sequence can return M-08 even if M-06A has not been opened.
- Never auto-correct the later times or decide which clock is right.
