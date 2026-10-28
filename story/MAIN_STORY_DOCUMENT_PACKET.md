# DEAD AIR — Main-Story Document Packet

*Working draft, version 0.1. Calendar dates remain placeholders. Times are shown in 24-hour format; external source clock bases remain as recorded and unresolved. Working values for this pass: numeric sequence `731904`; NR-041 receptions at `7.418 MHz CW`; initial event IDs are allocated in the Canonical Identifiers & Time Register.*

This packet is designed to be read in fragments and compared. No single document proves the cause of the incident. The central contradiction is that the official shutdown summary claims operations ended and equipment was secured, while other records preserve communications after the stated shutdown.

---

## DOC M-06A — Closed Incident File Cover Sheet

**Agency:** Regional Technical Review Office  
**File number:** 01-773  
**Classification:** INTERNAL — TECHNICAL INCIDENT  
**Status:** CLOSED  
**Record created:** [DATE TBD], 08:40  
**Archive ingestion:** [DATE TBD], 09:12  
**Subject:** Research Facility Operations Discontinuation

### Summary entered by Records Administration

This file contains the approved operations-discontinuation summary, equipment disposition confirmation, and supporting technical appendices supplied for retention. The file is considered administratively complete. The completeness status indicates that the required document categories were received or marked not applicable; it does not certify that every referenced communication or source record survives in this archive.

**Disposition:** Retain under incident-file schedule. No further action assigned.

**Index note:** Appendix pages are stored in a separate technical enclosure. Their ingestion order may not reflect the order in which the pages were authored or used.

---

## DOC M-07 — Operations Discontinuation Summary

**File:** 01-773  
**Document ID:** 01-773-SUM  
**Originating office:** Facility Operations Coordination  
**Document date:** [DATE TBD]  
**Event time referenced:** 18:00, [DATE TBD]  
**Received by Regional Technical Review:** 18:26, [DATE TBD]  
**Archive ingestion:** [DATE TBD], 09:12

### Summary

At 18:00 local facility time, the research operation was recorded as discontinued. Assigned personnel were directed to follow the approved departure procedure. Equipment under the operations inventory was reported secured, and access to active research areas was transferred to the designated custodial authority.

No further operational activity was authorized under the discontinued program.

The responsible unit reports that the equipment inventory was completed and that outstanding operational material was transferred or marked for retention in accordance with the applicable schedule. No unresolved operational exception was attached to this summary at the time of submission.

**Disposition recommendation:** Close the operations record and retain the summary with the incident file.

**Approval:** Operations Coordination — signature image unavailable in this copy.  
**Distribution:** Regional Technical Review; Records Administration.

### Records note

This summary records the responsible unit's submitted status. It is not an independent inventory of every device, communication path, or retained medium.

**What it establishes:** the official claim that operations ended, equipment was secured, and no unresolved operational exception was reported.

**What it does not establish:** that every system was physically inactive after 18:00, that every record was preserved, or that the submitted summary is a complete description of events.

---

## DOC M-08 — Technical Appendix: Communications Activity

**Parent file:** 01-773  
**Appendix ID:** 01-773-APP-C  
**Prepared by:** Technical Records Group  
**Document date:** [DATE TBD — NOT YET STANDARDIZED]  
**Archive ingestion:** [DATE TBD]  
**Cross-reference:** Communications sequence worksheet, enclosure C-4  
**Sequence field:** `731904`

### Extract: communications status

| Logged time | Route | Entry | Status |
|---|---|---|---|
| 18:17 | Internal route [origin field incomplete] → coordination channel | Sequence received; checksum field blank | RECEIVED |
| 18:19 | Coordination channel → internal relay | Repeat of sequence worksheet C-4 | ROUTED |
| 18:23 | Internal relay → [destination field incomplete] | Acknowledgement recorded | ACKNOWLEDGED |

**Technical Records comment**

The entries above were transcribed from the communications worksheet provided with the appendix. The source worksheet does not include a complete origin identifier. The time basis is listed as “local” on the source page; the source does not define whether this refers to the facility clock, relay clock, or receiving-office clock.

The appendix has been retained as supplied. No independent clock comparison was included in the enclosure.

**Handling note:** This appendix is associated with the discontinuation summary in the same incident file. Its association with the file should not be treated as confirmation that every entry occurred before or after the discontinuation event. Compare the timestamps and source fields before drawing a chronology.

**Critical comparison:** the summary cites discontinuation at 18:00, while this appendix contains entries at 18:17, 18:19, and 18:23. It is not yet known whether the appendix is misdated, delayed, misattributed, or a record of post-discontinuation communications.

---

## DOC M-09 — Communications Record 04-C

**Record ID:** 04-C  
**Record type:** Interstation communications log  
**Origin station:** [FIELD INCOMPLETE]  
**Receiving route:** Regional Operations relay  
**Record date:** [DATE TBD]  
**Event timestamps shown:** 18:19–18:23, [DATE TBD]  
**Archive ingestion:** [DATE TBD, later than the original incident file ingestion]  
**Source medium:** scanned worksheet; original carrier not held in this archive

### Extract

| Time shown | Route / field | Content | Receipt state |
|---|---|---|---|
| 18:19 | Internal relay | Sequence worksheet C-4 | RECEIVED |
| 18:21 | Route continuation | C-4 repeated without attached origin identifier | ROUTED |
| 18:23 | Destination acknowledgement | Receipt status entered; operator field blank | ACKNOWLEDGED |

**Sequence field:** `731904`  
**Origin identifier:** Not present in surviving copy  
**Operator initials:** Blank  
**Clock source:** Not stated  
**Correction history:** No correction notice attached

### Archive annotation

This record was located through a separate communications-log search, not through the incident file's original appendix index. Its route labels and sequence reference are consistent with the surviving appendix extract, but the archive has not established whether the two records derive from the same original worksheet or from independent copies.

**Records status:** Retained. Origin unresolved.

**What it establishes:** a surviving interstation log records the sequence, internal routing, receipt status, and timestamps later than the official discontinuation time.

**What it does not establish:** the origin station, physical source, accuracy of the clock, or relationship between this log and the NR-041 reception at Site 04.

---

## DOC M-05 — Site 04 Decoding Worksheet

**Station:** Remote Monitoring Site 04  
**Signal ID:** SIG-0005  
**Mode:** CW  
**Frequency:** [PENDING FREQUENCY PLAN]  
**Reception time:** [DATE TBD], [TIME TBD]  
**Decoder output:** `731904`  
**Identifier heard:** NR-041  
**Decode confidence:** High  
**Registry check:** No match

### Technician's note

The identifier was decoded consistently on repeat playback. The numeric sequence was recovered from the same reception, though the decoder confidence for the sequence is lower than for the identifier. The recording is retained with the raw event metadata and the current transcript.

**Caution:** A high-confidence identifier decode does not establish the transmitting station's identity. The sequence is an observed pattern; its meaning is not known at this stage.

*Placement rule:* this worksheet is found before or alongside the closed incident file, depending on player discovery. The numeric sequence `731904` must match M-08 and M-09 exactly.

---

## DOC M-02 — Registry Lookup Response

**Request:** Identifier verification — NR-041  
**Requesting station:** Remote Monitoring Site 04  
**Response source:** National Radio Monitoring Service registry  
**Response status:** COMPLETE

> No station record exists under identifier NR-041 in the current registry history. No historical assignment was returned by the available search.
>
> If the received identifier is believed accurate, submit a discrepancy report with reception details. A registry lookup does not independently verify the transmitter's origin.

**Search scope:** Current registry and retained historical assignment index.  
**Limitations:** The response does not certify that all historical station records have survived or that the signal was not received.

This is a routine, defensible registry response—not evidence that the registry is malicious or that the signal is impossible.

---

## DOC M-10A — Follow-up Technical Report

**Report ID:** [GENERATED AFTER INITIAL REPORT]  
**Related report:** [INITIAL NR-041 REPORT ID]  
**Linked records:** Site 04 worksheet; registry response; file 01-773 appendix; communications record 04-C  
**Submitted by:** Remote Monitoring Site 04  
**Purpose:** Request comparison of repeated sequence and post-discontinuation records

### Observations

A CW reception at Site 04 decoded as NR-041. The registry returned no station match. A later reception produced a similar identifier under different reception conditions. The recovered numeric sequence also appears in technical records associated with closed incident file 01-773 and communications record 04-C.

The incident summary records operations discontinuation at 18:00. The appendix and 04-C contain communications entries timestamped after 18:00. The records available to Site 04 do not establish whether the timestamps use a common clock or whether the documents derive from independent originals.

### Requested action

Please verify the record relationship, identify the origin station if available, and advise whether the incident-file chronology requires correction.

### Technical limitation

The Site 04 recordings establish what was received at Site 04. They do not independently establish the origin of the transmission or the accuracy of the external archive timestamps.

---

## DOC M-10B — Regional Operations Response

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

**Archive status:** Response retained. Original report remains unchanged.

The closure is institutionally plausible and careful. It is also unsatisfying: the records are linked by a recurring sequence, but the office declines to treat that pattern as a verified source relationship.

---

## Optional deep documents — not required to solve the main contradiction

### DOC M-11 — Personnel Disposition Index (outline only)

A restricted personnel index contains a date overlap or duplicate-looking disposition entry. It should introduce uncertainty about how personnel records were merged or retained, not prove that one person occupied two places or that a person is responsible for the incident. Exact names and dates are not locked.

### DOC M-12 — AI Evaluation Extract (outline only)

A technical evaluation references predictions or classifications derived from an input set that is not present in the surviving archive. A recommendation page is missing. The record cannot establish whether the input was omitted, stored elsewhere, or never attached. It must not prove the AI caused the incident or understood the connection.

### DOC M-13 — Independent Review Chronology (outline only)

A later-discovered review cites a report whose visible date appears later than the review's own date. Both dates are retained as printed. No correction or authoritative source resolves the discrepancy.

### DOC M-14 — Cross-Station Calibration Comparison (outline only)

Two recordings that appear to come from different monitoring stations contain a similar background calibration tone. The similarity warrants comparison but does not prove a common transmitter, tampering, or a supernatural source.

---

## Player-facing discovery order

1. M-01/M-05: NR-041 reception and decoding worksheet.
2. M-02: registry response says no such station is recorded.
3. M-03: Mara closes the initial verification task while preserving evidence.
4. M-04: NR-041 recurs under different conditions.
5. M-06/M-07: closed incident file and official discontinuation summary.
6. M-08: appendix entry times conflict with the summary's stated discontinuation time.
7. M-09: separately found 04-C repeats the sequence and shows internal routing/receipt, but has no origin field.
8. M-10A/M-10B: follow-up report is administratively closed without resolving the chronology.
9. Optional M-11–M-14: deepen the pattern without solving the cause.

Discovery can vary, but every essential record must have a recovery path in the archive. The sequence `731904` is the current working value and must be propagated consistently through all records.
