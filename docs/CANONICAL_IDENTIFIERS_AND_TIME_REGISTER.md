# DEAD AIR — Canonical Identifiers & Time Register

*Working control document, version 0.1, 28 October 2026. This is an inventory and consistency-control sheet, not approval to resolve open canon.*

## Purpose and use

This register is the single place to check names, identifiers, timestamps, frequencies, and numeric-sequence references before drafting or revising story content. It records what the current documents actually say, distinguishes working canon from placeholders, and flags mismatches for an explicit decision.

**Do not treat an item as locked merely because it appears in this register.** Status labels mean:

- **Working canon** — repeatedly used and currently intended, but still changeable by the project owner.
- **Provisional** — a proposed name, title, or technical choice not yet approved as final.
- **Draft value** — appears in a current narrative draft but is explicitly not locked.
- **Placeholder** — unresolved and must not be replaced by an invented value.
- **Conflict** — two current documents disagree; preserve and flag the mismatch until it is deliberately decided.
- **Unknown** — the source does not establish the value.

## 1. Names, organizations, and locations

| Item | Current value | Status | Notes / limits |
|---|---|---|---|
| Fictional regulator | National Radio Monitoring Service (NRMS) | Provisional | Used in project overview; confirm or rename globally. |
| Player workplace | Remote Monitoring Site 04 | Working canon / label provisional | Remote civilian spectrum-monitoring station. Exact geographic location is not fixed. |
| Supervisor | Mara Venn | Provisional | Regional Operations supervisor. Do not imply omniscience or a confirmed sinister role. |
| Regional records office | Regional Technical Review Office | Draft value | Appears as the originating/receiving office in incident-file documents; relationship to NRMS/Regional Operations needs consistency review. |
| Supervisor's office | Regional Operations | Working label | Used in Mara's correspondence and transfer chain. Exact organizational chart is not fixed. |
| Research facility | Unnamed government research facility | Unnamed by design for now | Government research combined advanced AI with experimental particle-physics research. Do not invent a facility or program name. |
| Research project/program name | Not set | Unknown / placeholder | Decide whether to name it at all. |
| Silent Site | “Silent Site” | Working branch label | Optional records-discrepancy branch, not yet a formal facility name. |
| Former Records Continuity Unit | “Records Continuity Unit” | Draft value | Appears in Silent Site branch as a former unit; does not establish wrongdoing. |

## 2. Core identifiers and record IDs

| Identifier | Meaning / current use | Status | Rules |
|---|---|---|---|
| `NR-041` | Unregistered CW identifier heard at Site 04 | Working canon | Registry says no station record exists. Do not assign a real transmitter, station, entity, or cause. |
| `01-773` | Closed incident file | Working canon | Main file ID; cover sheet and related records refer to it. Check future IDs for collisions. |
| `01-773-SUM` | Operations Discontinuation Summary | Draft ID | M-07 document ID. |
| `01-773-APP-C` | Technical Appendix: Communications Activity | Draft ID | M-08 appendix ID. |
| `04-C` | Communications Record / interstation communications log | Working canon | Origin field incomplete. Record's separate discovery does not prove independent source material. |
| `C-4` | Communications worksheet / enclosure reference | Draft value | Used in M-08 and M-09 as “sequence worksheet C-4” or “enclosure C-4.” Confirm exact nomenclature and casing globally. |
| `NR-041` sequence | Numeric sequence decoded at Site 04 and referenced in M-08/M-09 | Placeholder | No canonical digits have been selected. Never make up digits in a player-facing artifact. |
| `SIG-[…]` | Signal event identifiers | Placeholder | The opening script and document packet contain pending Signal IDs. Allocate from one global sequence only after the event register is defined. `SIG-0042` is only an illustrative example in the receiver specification, not an assigned story ID. |
| `A-001`, `A-002` | Opening-shift assignments | Draft assignment IDs | Used in opening script. |
| `A-003`–`A-006` | Main-story comparison and review assignments | Working assignment IDs | Scripts exist; release-scope decisions remain open. |
| `M-01`–`M-14` | Main-story evidence/document ledger IDs | Working ledger IDs | Some entries are drafted, some optional or outlined. M-06 is a grouped reference; M-06A is the cover sheet. |
| `M-06A` | Closed Incident File Cover Sheet | Draft artifact ID | File number is 01-773. |
| `M-07` | Operations Discontinuation Summary | Draft artifact ID | Claims operations discontinued at 18:00 and equipment was reported secured. |
| `M-08` | Technical Appendix: Communications Activity | Draft artifact ID | Contains entries at 18:17, 18:19, 18:23. |
| `M-09` | Communications Record 04-C | Draft artifact ID | Packet says timestamps 18:19–18:23; assignment script currently differs on one row. |
| `M-10A` / `M-10B` | Follow-up report / Regional Operations response | Draft artifact IDs | Closes the assignment without resolving chronology or source relationship. |
| `SS-01`–`SS-08` | Optional Silent Site evidence chain | Working branch IDs | Keep independent from the main incident unless a future explicit canon decision changes this. |
| `W1KDX`, `N4HLM` | Example call signs in evidence-ledger placeholder register | Placeholder | Not assigned story canon; validate before use and avoid accidental real-person association. |

## 3. Current timestamp inventory

The story packet explicitly says dates and times are fictional draft placeholders and are not locked canon. Keep the displayed values below as they currently appear; do not normalize them silently.

| Artifact / field | Current value | Status | What is and is not established |
|---|---|---|---|
| M-06A record created | `[DATE TBD], 08:40` | Placeholder date; draft time | Creation time, not necessarily event time. |
| M-06A archive ingestion | `[DATE TBD], 09:12` | Placeholder date; draft time | Ingestion time. Date and relationship to other ingestion events are not fixed. |
| M-07 event time referenced | `18:00, [DATE TBD]` | Draft value | Official summary's claimed discontinuation time, not verified ground truth. “Local facility time” is stated in the summary. |
| M-07 received by Regional Technical Review | `18:26, [DATE TBD]` | Draft value | Receipt time. Do not equate it with event or creation time. |
| M-07 archive ingestion | `[DATE TBD], 09:12` | Placeholder date; draft time | Same clock reading as M-06A's ingestion field, but date and shared-clock basis are not established. |
| M-08 logged entries | `18:17`, `18:19`, `18:23` | Draft values | Source calls basis “local” but does not define whether facility, relay, or receiving-office clock. Origin/destination fields are incomplete. |
| M-09 packet header | `18:19–18:23, [DATE TBD]` | Draft range | Packet summary says the record's event timestamps are 18:19–18:23. |
| M-09 table in document packet | `18:19`, `18:23` | Draft values | Current packet excerpt shows internal relay received at 18:19 and destination acknowledgement at 18:23. |
| M-09 table in assignment script | `18:19`, `18:21`, `18:23` | **Conflict** | Assignment script includes a middle row at 18:21 that is not present in the current document-packet M-09 table. Decide whether the row is missing from the packet or should be removed from the assignment script; do not silently choose. |
| M-08/M-09 chronology relationship | Later than the M-07 claimed 18:00 discontinuation | Deliberate unresolved contradiction | Clock basis, date alignment, document authenticity, delay, and source relationship remain unresolved. The mismatch is story evidence, not permission to decide which record is correct. |
| M-10A report date / M-10B response date | `[DATE TBD]` | Placeholder | No global date standard or fixed calendar date yet. |
| Site 04 first and repeat NR-041 reception times | `[TIME PLACEHOLDER]` / pending chronology pass | Placeholder | Must be entered into the event register before player-facing text is finalized. |
| Silent Site branch dates | Not fixed | Unknown / placeholder | Do not invent dates or imply exact elapsed time from the existing package trail. |
| Global calendar / time standard | Not selected | Open decision | Decide date format, timezone/clock labels, day progression, and how “local” is represented. |

### Timestamp vocabulary rule

Every future timestamped record should distinguish, where applicable:

1. **Claimed event time** — when the document says an event happened.
2. **Document creation time** — when the record was written or generated.
3. **Transmission time** — when information was sent.
4. **Receipt time** — when a receiving system or office logged it.
5. **Archive ingestion time** — when the archive accepted the record.
6. **Correction/version time** — when a later correction was entered.

If the source does not identify the type or clock basis, write **unknown** or preserve the source's wording. Do not infer that two “local” timestamps use the same clock.

## 4. Frequency, mode, and receiver values

| Item | Current value | Status | Action |
|---|---|---|---|
| Example frequency | `7.418 MHz CW` | Explicitly illustrative only | Do not treat as the NR-041 frequency or opening time-standard frequency. Verify the eventual frequency plan before assigning story events. |
| Opening time-standard frequency | Not set | Placeholder | Choose after the frequency plan and band ranges are approved. |
| NR-041 first reception frequency | Not set | Placeholder | One global event entry must supply the value. |
| NR-041 recurrence frequency | Not set | Placeholder | Decide whether it matches or differs only when the event plan requires it; do not imply source identity from frequency alone. |
| M-08/M-09 frequencies | Not specified | Unknown | Do not invent them for archival documents unless a source artifact needs one. |
| Receiver bands/modes | Simplified HF/VHF/UHF; AM/FM/NFM/USB/LSB/CW | Proposed system design | These are simulated receiver capabilities, not evidence that a story event has been assigned a frequency. |
| CW timing / numeric sequence decode | Pending global pass | Placeholder | Identifier confidence can remain higher than numeric-sequence confidence. |

## 5. Evidence and interpretation limits

These are register-level rules for all future documents, UI labels, and reports:

- A registry result that has no NR-041 entry does not prove the reception did not occur.
- A successful decode of `NR-041` does not identify the transmitter.
- Matching numeric sequences or worksheet references do not prove a common transmitter, a shared original source, or a cause.
- The separate discovery of 04-C does not prove that it is independent evidence; the archive has not established whether it derives from the same worksheet or an independent copy.
- The 18:00 shutdown entry is an official claim. The later entries are timestamped records with incomplete clock/origin information. Neither side should be silently privileged as ground truth.
- “Received,” “routed,” and “acknowledged” are record statuses, not proof that the underlying communication's origin is known.
- The Silent Site package trail supports a records discrepancy only. It does not prove deliberate destruction, a cover-up, or a main-story connection.
- The central phenomenon, its intentions, and any causal role for experimental AI remain unconfirmed.
- Original artifacts are immutable. Corrections must be new, linked versions with provenance; do not rewrite the old artifact in place to hide a conflict.

## 6. Required normalization pass

Before the story packet is considered script-ready, complete these actions in order:

1. **Approve or rename provisional proper nouns:** NRMS, Site 04 label, Mara Venn, Regional Technical Review Office, and the office relationship between Regional Operations and the technical review office.
2. **Create one event/time table** covering the opening shift, both NR-041 receptions, assignment availability, M-06A through M-10B, and any date-bearing Silent Site records. Include event time, creation time, receipt time, ingestion time, timezone/clock basis, and status separately.
3. **Resolve the M-09 18:21 mismatch explicitly** by editing the document packet or assignment script in a new commit. Preserve the uncertainty about source and clock basis regardless of which table is corrected.
4. **Select and propagate one numeric sequence** across M-05, M-08, M-09, assignment prompts, reports, and notebook text. Until then, keep it a placeholder everywhere.
5. **Allocate Signal IDs centrally** to the first reception, recurrence, time standard, and other authored events. Do not reuse the receiver spec's illustrative `SIG-0042` as if already canon.
6. **Approve a frequency plan** before assigning the opening time standard or NR-041 frequencies. Record frequency, mode, occupied bandwidth if relevant, and whether each value is story canon or a UI example.
7. **Set date format and time semantics** without forcing the disputed records into a single chronology.
8. **Run a cross-document string audit** for all names, IDs, dates, times, frequencies, and sequence references; report unresolved mismatches rather than repairing them silently.

## 7. Open decisions and linked control documents

Use this register with:

- [Canon Decisions & Open Questions](CANON_AND_OPEN_QUESTIONS.md)
- [Master Chronology & Evidence Ledger](MASTER_CHRONOLOGY_EVIDENCE_LEDGER.md)
- [Prioritized Design Decision Register](PRIORITIZED_DESIGN_DECISION_REGISTER.md)
- [Main-Story Document Packet](../story/MAIN_STORY_DOCUMENT_PACKET.md)
- [Main Story Assignment Scripts](../story/MAIN_STORY_ASSIGNMENT_SCRIPTS.md)
- [Opening Shift Playable Script](../story/OPENING_SHIFT_PLAYABLE_SCRIPT.md)

This document does not itself approve any unresolved canon, chronology, sequence, frequency, or implementation decision.
