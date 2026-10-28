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


# A-005 — Find Communications Record 04-C

**Status:** Core. **Purpose:** Add a separately discovered record with matching sequence and routing/receipt fields while keeping its source and origin unresolved.

## Assignment card

**Title:** Search communications records  
**Category:** Archive / interstation logs  
**Priority:** Follow-up  
**Status:** OPEN

> A technical enclosure references communications worksheet C-4. Search retained interstation logs for the worksheet reference, sequence field, or related route labels.
>
> Record the origin, clock source, and receipt fields exactly as they appear. Leave incomplete fields unresolved.

Suggested search terms: 04-C, C-4, [canonical sequence TBD], internal relay, receipt status. Exact syntax is not required.

## Search result

> **04-C — Interstation Communications Log**  
> Record type: Scanned worksheet  
> Origin station: Field incomplete  
> Receiving route: Regional Operations relay  
> Archive status: Retained  
> Source medium: Original carrier not held in this archive

**Search provenance**

> This record was found through a separate communications-log search. It was not returned as an attachment to file 01-773.

“Separate search” describes the discovery route; it does not prove the records derive from independent originals.

## M-09 — Player-facing document

| Time shown | Route / field | Content | Receipt state |
|---|---|---|---|
| 18:19 | Internal relay | Sequence worksheet C-4 | RECEIVED |
| 18:21 | Route continuation | C-4 repeated without attached origin identifier | ROUTED |
| 18:23 | Destination acknowledgement | Receipt status entered; operator field blank | ACKNOWLEDGED |

**Record fields**
- Sequence: [canonical numeric sequence — TBD]
- Origin identifier: not present in surviving copy
- Operator initials: blank
- Clock source: not stated
- Correction history: no correction notice attached

**Archive annotation**

> Route labels and sequence reference are consistent with the surviving appendix extract. The archive has not established whether the two records derive from the same original worksheet or from independent copies.

## Compare M-08 and M-09

| Comparison point | M-08 appendix | M-09 record 04-C |
|---|---|---|
| Sequence reference | C-4 / [sequence TBD] | C-4 / [sequence TBD] |
| Later timestamps | 18:17, 18:19, 18:23 | 18:19, 18:21, 18:23 |
| Routing information | Present, partly incomplete | Present, partly incomplete |
| Receipt / acknowledgement | Present | Present |
| Origin | Incomplete | Absent from surviving copy |
| Clock source | “Local”; exact clock undefined | Not stated |
| Source relationship | Not independently established | Not independently established |

**Player prompt**

> Which statement best describes the comparison?

**A — Supported**

> Both surviving records contain the same sequence reference and later-timestamped routing/receipt entries. The origin and clock basis remain incomplete.

**B — Stronger hypothesis**

> The records may share a worksheet or communications path, but the archive does not establish whether they are independent copies.

**C — Unsupported certainty**

> Both records prove that NR-041 transmitted from the research facility after shutdown.

Feedback for C:

> The records do not identify NR-041 as the origin station, and the origin and clock fields are incomplete. You can save this as a hypothesis, but it cannot be entered as a verified finding.

All choices preserve progression.

## Completion response

**System message**

> Comparison saved. The two records remain separate. Their shared sequence reference is searchable, but no source relationship has been verified.

**Status:** CLOSED — COMMUNICATIONS RECORD RETAINED  
**Unlock:** A-006, Request chronology and record-relationship review.

## Recovery and out-of-order rules

- A search for 04-C, C-4, or the sequence can find M-09 without opening M-08 first.
- If M-09 is found first, opening M-08 later triggers the comparison prompt.
- If the player does not compare manually, A-006's report form can offer both records as suggested attachments.
- Never label M-09 “independent evidence” as a fact. It is independently discovered, but source independence is unverified.

# A-006 — Request chronology and record-relationship review

**Status:** Core. **Purpose:** Let the player submit a carefully bounded report and receive an administratively plausible closure that does not resolve the chronology.

## Assignment card

**Title:** Request chronology and record-relationship review  
**Category:** Technical report / Regional Operations  
**Priority:** Follow-up  
**Status:** OPEN

> Compare the Site 04 receptions with the retained technical records. Request review of the sequence reference, timestamps, and available source fields.
>
> Distinguish direct observations from inferences. If a source or clock basis is not established, state that limitation rather than filling the field by assumption.

## Report composition screen

Prepopulate links where available:
- M-01 — first NR-041 reception
- M-02 — registry response
- M-04 — recurring NR-041 reception
- M-05 — decoding worksheet
- M-07 — operations discontinuation summary
- M-08 — technical appendix
- M-09 — communications record 04-C, if discovered

The player may remove optional links or add notebook notes. Evidence remains available regardless of attachment choices.

### Observation field

Offer three starting templates.

**A — Concise**

> NR-041 was decoded during two Site 04 receptions. The registry returned no matching station. A matching sequence reference appears in file 01-773 technical records and, where available, Communications Record 04-C. The official summary states discontinuation at 18:00; later entries are timestamped 18:17–18:23. Origin and clock basis are not established.

**B — Detailed**

> The Site 04 records preserve two receptions decoded as NR-041 under different reception conditions. The registry response contains no matching station record. The numeric sequence recovered from the reception appears in the technical appendix associated with file 01-773 and in Communications Record 04-C. The discontinuation summary records an event time of 18:00, while the appendix and 04-C show later timestamps. The available records do not establish a shared clock basis, an origin station, or whether the two external records derive from independent originals.

**C — Write my own**

Allow free text. Show this reminder:

> Separate observations, institutional claims, and hypotheses. A report may request review without claiming a source or cause.

### Requested action field

Default:

> Verify the relationship between the cited records, identify the origin station if supported by surviving source data, and advise whether an independently verified clock comparison or chronology correction is available.

Alternative: retain for technical review without requesting a conclusion.

### Technical limitations field

Default:

> Site 04 recordings establish the received content and local receiver metadata. They do not independently establish the transmission origin. External records contain incomplete origin fields and do not specify a common clock source.

### Player stance selector

- Strictly factual
- Factual plus explicit hypotheses
- Hold report as draft

The first two submit to the same review path. The third saves a draft and leaves the assignment open. An assertive stance does not unlock more story content.

## Validation feedback

If the player writes “The research facility transmitted NR-041 after shutdown,” show:

> This statement goes beyond the linked records. None of the attached origin fields identifies NR-041 as the source, and the clock basis is not established.
>
> You can submit it as a hypothesis with that label, revise it to a factual observation, or save the report as a draft.

Buttons: Mark as hypothesis and continue; Revise wording; Save draft. All remain available.

## Submission receipt

> **REPORT RECEIVED**  
> Report ID: [GENERATED REPORT ID]  
> Status: AWAITING REVIEW  
> Linked records: [COUNT]  
> Original evidence: Retained  
> Corrections made to source records: None

**Queue note**

> Regional Operations will review this during active work time. The report will not expire if you leave the shift or close the application.

No real-world countdown. Simulated queue time advances only during active play.

## M-10B — Mara Venn response

**From:** Mara Venn, Regional Operations  
**To:** Remote Monitoring Site 04  
**Subject:** Follow-up review — NR-041 / incident-file cross-reference  
**Status:** CLOSED — NO VERIFIED REGISTERED-STATION LINK  
**Response date:** [DATE TBD]

> Your comparison has been added to the records package.
>
> The registry does not identify NR-041 as a registered station, and the available copy of Communications Record 04-C does not provide a complete origin field. The incident file's appendix is associated with the discontinuation summary, but association within an archive is not proof of a shared clock or a verified source.
>
> We have not established a registered-station link between the Site 04 reception and the records in file 01-773. The material also falls outside the scope of the current identifier-verification assignment. The request is therefore closed without a finding on the underlying chronology.
>
> Retain the original recording, transcript, registry response, and cited records. If a source record or independently verified clock comparison becomes available, submit it as a new linked report. Do not amend the existing report to imply a source or chronology that has not been established.

**System receipt**

> **REVIEW CLOSED**  
> Finding: No verified registered-station link  
> Chronology: Unresolved  
> Original report: Retained  
> Linked evidence: Retained  
> Source records modified: No

**Assignment state:** CLOSED — NO VERIFIED REGISTERED-STATION LINK

## Post-response actions

Offer quiet, ordinary actions:
- Open the submitted report
- Review linked evidence
- Add a private notebook interpretation
- Search the archive
- Return to routine monitoring

Do not force a dramatic cutscene. Further story depth should come from player curiosity, not a sudden alert.

**Notebook prompt**

> Regional Operations has closed the review without resolving the chronology. The submitted report and its evidence remain available. You may continue searching for source records, clock comparisons, or related archive material.

Optional deep-archive leads appear only when the player finds relevant cross-references. Do not reveal M-11 through M-14 as a mandatory checklist.

## A-006 recovery and alternate paths

- **M-09 not found yet:** allow submission with M-08 and Site 04 evidence. The response must reflect only the records attached. After M-09 is found, enable “Create linked supplement” rather than rewriting the submitted report.
- **Minimal report:** use the same core response, accurately reflecting the attached records.
- **Draft retained:** assignment remains open; archive search continues to work.
- **Player rejects Mara's conclusion:** preserve the message and allow further searches. No trust penalty may prevent evidence.
- **Deep archive material found first:** preserve it. Optional artifacts can be attached, but cannot resolve the core chronology.
- **App closed:** save report and queue state. No time passes while closed; no evidence expires.

## Cross-assignment continuity checklist

- [ ] A-003 preserves both receptions without establishing a common transmitter.
- [ ] A-004 presents the official 18:00 shutdown claim and later appendix entries without deciding which is wrong.
- [ ] A-005 makes clear that separate discovery does not prove independent origin.
- [ ] A-006 distinguishes observations, institutional claims, and hypotheses.
- [ ] M-10B closes the assignment without resolving chronology.
- [ ] Original reports, source records, and transcripts remain immutable.
- [ ] Every discovery has an archive/recovery route.
- [ ] Exact dates, frequencies, Signal IDs, and the numeric sequence remain placeholders until standardized.
- [ ] Optional deep documents do not gate the main narrative.
- [ ] This document is narrative/UI specification only; no game code is started.
