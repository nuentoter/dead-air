# DEAD AIR — Assignment & Evidence Dependency Map

*Working design document, version 0.1. This is the assignment/recovery contract for the active prototype. The first-release scope uses A-001 through A-006; future assignment IDs still require a collision check.*

## 1. Rules

- No critical evidence depends on catching a live transmission, perfect tuning, a particular mode, a minimum recording duration, or exact report wording.
- Missed live events remain available as retained events/archive leads. Preserve provenance; never pretend the player manually recorded something they missed.
- Assignments do not expire. No real-world waiting, deadlines, streaks, or penalties for closing the app.
- Optional exploration changes discovery order, not access to the critical path.
- Administrative closure can end a task without resolving its underlying question.
- Original evidence is immutable. Corrections and reinterpretations create linked records; never silently rewrite originals.
- Decode confidence describes reading reliability, not source identity or registry truth.
- Cautious factual reports progress just as fully as more assertive reports.
- Never confirm what lies beyond the connection, its intentions, or whether experimental AI caused the incident.

## 2. Dependency overview

~~~text
A-001 Receiver startup and time standard
  -> A-002 Initial identifier verification
     -> M-01 / M-05: NR-041 event and decoding worksheet
     -> M-02: registry says no NR-041 station is recorded
     -> Initial report
        -> M-03: Mara closes verification task, retains evidence
           -> A-003 Compare recurring identifier
              -> M-04: NR-041 recurs under different conditions
              -> M-05: sequence/transcript with confidence limits
                 -> A-004 Search incident-file references
                    -> M-06A: closed incident file 01-773 cover
                    -> M-07: official discontinuation summary
                    -> M-08: appendix entries at 18:17 / 18:19 / 18:23
                       -> A-005 Search communications logs
                          -> M-09: Communications Record 04-C
                             -> A-006 Request chronology review
                                -> M-10A: follow-up report
                                -> M-10B: administrative closure; chronology unresolved

Optional deep archive: A-007 -> M-11; A-008 -> M-12;
A-009 -> M-13; A-010 -> M-14.
Independent optional branch: A-020 -> Silent Site SS-01 through SS-08.
~~~

This is conceptual, not a mandatory click sequence. If M-07 or M-09 is discovered early, keep it and update assignments when prerequisites are met. Never hide a record already found.

## 3. Assignment register

**Core** = required for the intended main narrative. **Optional** = adds depth but does not gate the main endpoint. **Draft** = proposed, not locked.

| Assignment | Entry / action | Outputs and completion |
|---|---|---|
| A-001 — Verify receiver startup and time standard (existing) | New-shift handover; power RX on and open time-standard panel. | Startup status. Complete when receiver is ready and panel opened; no recording score. |
| A-002 — Review identifier reported during routine monitoring (existing) | A-001 complete; inspect retained CW event and request registry lookup. | M-01/M-05 working evidence and M-02. Complete when registry result viewed. |
| Initial NR-041 discrepancy report | M-01 and M-02 available; submit factual report or save draft. | Player report, linked event/transcript, then M-03. Wording cannot gate evidence. |
| A-003 — Compare recurring identifier (Core, proposed) | Initial task closed or recurrence available; compare receptions. | M-04 and sequence/transcript details. Source remains unknown. |
| A-004 — Locate incident-file reference (Core, proposed) | Sequence available or archive search performed; search sequence/index/enclosure. | M-06A, M-07, M-08 available. No authenticity judgment required. |
| A-005 — Find communications record (Core, proposed) | M-08 found, or broad search locates 04-C; search by sequence, route, or time. | M-09 opened; incomplete origin fields reviewed. |
| A-006 — Request chronology review (Core, proposed) | M-04/M-05 and M-07/M-08 available; M-09 encouraged but not a hard gate. | M-10A report and M-10B response. Closes without resolving chronology. |
| A-007 — Review personnel disposition index (Optional, proposed) | Deep archive/restricted index search. | M-11 date overlap or duplicate-looking disposition; no definitive identity explanation. |
| A-008 — Search AI evaluation attachments (Optional, proposed) | Deep archive or cross-reference. | M-12 extract/missing page; no conclusion about AI responsibility. |
| A-009 — Compare independent review chronology (Optional, proposed) | Search review references. | M-13 date mismatch; preserve both printed dates. |
| A-010 — Compare cross-station calibration (Optional, proposed) | Two retained recordings available. | M-14 similar background tone; alternative explanations preserved. |
| A-020 — Reconstruct Silent Site transfer trail (Optional, proposed) | Search decommissioned-site history or neighboring-station archive. | SS-01–SS-08; package trail documented, log disposition unresolved. |
| Procedural monitoring assignments (repeatable) | Tune, classify, record if useful, search archive, submit report. | Routine records and independent small stories; no quota or deadline. |

### Assignment behavior

- Use OPEN, IN PROGRESS, AWAITING REVIEW, and CLOSED states.
- The player may inspect the archive/notebook before accepting assignments.
- Queues progress during active play, not while idle or the app is closed.
- Incomplete reports may request clarification but never remove evidence.
- If A-006 is submitted before M-09 is found, return a limited review and allow an append-only supplement after M-09 appears. Never rewrite the original report.
- Main-story closure is not a claim that the mystery is solved.

## 4. Critical evidence map

| Artifact | Route | Establishes | Does not establish / recovery |
|---|---|---|---|
| M-01 — First NR-041 detection | A-002 or waterfall | CW reception decodes as NR-041. | Source/location unknown. Recover through retained event if missed. |
| M-02 — Registry response | Lookup or archive search | Available registry history has no NR-041 station. | Registry completeness/source unknown. Lookup remains available from archive. |
| M-03 — Supervisor closure | Initial report | Mara closes verification as a registry discrepancy and says to retain evidence. | Does not prove duplicate/source. Message remains archived. |
| M-04 — Recurrence | Next routine shift or retained A-003 event | NR-041 returns with different pattern/timing and weaker/fading reception. | Same physical transmitter not proven. Persistent event summary/transcript. |
| M-05 — Decoding worksheet/sequence | Event transcript and later comparison | Identifier and sequence recovered at stated confidence levels. | Sequence meaning unknown. Replay/reopen event or use transcript. |
| M-06A — Incident file cover | Search by sequence/index | File 01-773 is retained and marked administratively closed/complete. | Does not prove all source records survive. Index reference remains. |
| M-06A — Closed incident file cover | Search for 01-773 or incident-file references. | File reference 01-773 is marked CLOSED / COMPLETE administratively. | Does not certify all attachments are present or reconcile chronology. |
| M-07 — Shutdown summary | Open incident file summary | Official claim: discontinuation at 18:00 and equipment secured. | Completeness/truth unknown. Retained copy remains. |
| M-08 — Technical appendix | Enclosure C-4, time, or sequence search | Entries at 18:17, 18:19, 18:23 appear after stated shutdown. | Could be misdated, delayed, misattributed, or post-shutdown. Keep appendix searchable. |
| M-09 — Communications Record 04-C | Separate log search by sequence/route/time | Sequence reference, internal routing/receipt, later times, incomplete origin. | Independent original/source/clock basis unknown. Search via M-08 or archive. |
| M-10A — Follow-up report | A-006 form | Player's comparison and limitations. | Does not establish source/chronology. Report immutable. |
| M-10B — Regional Operations response | Review queue | Mara closes because no registered-station link is verified and scope is limited. | Does not disprove evidence or reveal Mara's knowledge. Response archived. |

## 5. Optional branches

### Deep archive

| Artifact | Adds | Must not prove |
|---|---|---|
| M-11 — Personnel Disposition Index | Date overlap or duplicate-looking disposition. | One person was definitely in two places or caused the incident. |
| M-12 — AI Evaluation Extract | Missing input/recommendation page in a technical evaluation. | AI caused the incident, understood the connection, or sourced NR-041. |
| M-13 — Independent Review Chronology | Review date appears earlier than a cited report. | Which date is wrong or which record was altered. |
| M-14 — Cross-Station Calibration Comparison | Similar background calibration tone in two recordings. | Shared transmitter, tampering, or supernatural cause. |

These files are optional depth; their absence must not make the main story feel incomplete.

### Silent Site

| Artifact | Discovery route | Direct finding / limits |
|---|---|---|
| SS-01 — Closure notice | Decommissioned-site history | Transfer marked complete; equipment inventory received; operational-log transfer partial; final logs not listed. |
| SS-02 — Neighboring-station recording | Search neighboring station archive | Incomplete ordinary conversation mentions something going back to Silent Site; object, purpose, timing unclear. |
| SS-03 — Transfer receipt | Follow SS-02 or search transfer records | Package dispatched to Regional Operations; no contents inventory/signature available. |
| SS-04 — Regional Operations receipt index | Search by transfer reference | Package indexed as received; contents unverified; inventory absent; initials illegible. |
| SS-05 — Obsolete stamp | Compare receipt with department directory | Former Records Continuity Unit stamp; reorganization alone is not suspicious. |
| SS-06 — Package inventory | Search former unit closure procedures/inventory | Correspondence and equipment forms listed; operational logs absent; media appendix blank/unsigned. |
| SS-07 — Final disposition index | Search retention index | Package processed under standard retention; package unavailable; no itemized disposal record. |
| SS-08 — Final report | Compile records and submit | Records discrepancy remains; package trail exists but logs' ultimate fate is unknown. |

Silent Site must not imply deliberate destruction, a culprit, cover-up, or main-story connection. The logs may have been separately transferred, never inventoried, retained elsewhere, or never included.

## 6. Player knowledge checkpoints

| Depth | Reasonable conclusion | Not established |
|---|---|---|
| Opening | NR-041 was received; registry has no match; first task closed. | Source is impossible, supernatural, AI-generated, or at a known site. |
| Recurrence | Identifier recurs under different reception conditions; sequence can be compared. | Same physical transmitter. |
| Incident-file comparison | Official summary says shutdown at 18:00; appendix lists later activity. | Shutdown was fake or appendix is correctly dated/authenticated. |
| Independent log comparison | 04-C records sequence/routing/receipt after shutdown; origin incomplete. | 04-C is independent original or came from a known station. |
| Administrative closure | Regional Operations declines a registered-station finding and closes task. | Mara knows the truth, is malicious, or disproves the evidence. |
| Deep archive | Records share references, date discrepancies, missing attachments, or tone similarities. | One authoritative explanation. |
| Silent Site | Package dispatched and indexed as received; inventory omits operational logs. | Logs were deliberately destroyed or branch connects to main incident. |

## 7. Fail-forward matrix

| Player behavior | Required response | Never do this |
|---|---|---|
| Misses NR-041 live | Keep event in A-002/archive. | Permanently lose first detection. |
| Does not manually record | Preserve recoverable copy with correct provenance. | Claim they manually recorded it. |
| Poor mode/bandwidth | Offer consistent alternate decode/transcript/replay. | Make tutorial error block evidence. |
| Identifier decodes, sequence does not | Keep identifier evidence; allow later replay/comparison. | Force certainty about sequence. |
| Minimal report or delayed submission | Continue same chain; assignment stays open. | Lock recurrence/file or expire task. |
| Reads M-07 before M-08 | Both remain accessible; contradiction appears when M-08 is read. | Hide M-08 due to order. |
| Finds M-09 before M-08 | Preserve discovery and compare later. | Force re-finding. |
| Submits A-006 before M-09 | Limited review; later append-only supplement allowed. | Rewrite original or hide M-09. |
| Disagrees with Mara | Preserve notes and allow independent search. | Treat disagreement as failure. |
| Ignores deep archive | Main story still reaches its endpoint. | Mark main story incomplete. |
| Abandons Silent Site | Leave open or mark unresolved. | Imply destruction/main-case link. |
| Closes app mid-shift | Save state; no time passes while closed. | Penalize or permanently miss clues. |

## 8. Archive search and data requirements

Suggested search paths: NR-041 / registry discrepancy; canonical sequence (TBD) / worksheet / C-4; 01-773 / discontinuation / technical appendix; 04-C / internal relay / receipt status; Silent Site / closure package / Records Continuity Unit / retention index. Support partial identifiers and broad categories. Distinguish exact references from text matches and speculative notebook links. Only create artifact links where records support a reference.

Each artifact should track, where available: stable ID/title; source/parent and responsible office; event, creation, receipt, archive-ingestion, and correction times as separate fields; explicit blank/unknown status for origin/operator/signature/clock; version history; discovery and recovery routes; and evidence class (direct observation, registry response, institutional claim, archive metadata, inference, or unresolved hypothesis). Do not guess missing timestamps.

## 9. Open decisions

1. Working numeric sequence `731904` (meaning unknown; verify it is propagated in every linked artifact).
2. Global date standard and exact incident-document dates.
3. Frequency plan and Signal IDs are assigned in the canonical register; exact CW keying cadence, calendar dates, and reception timestamps remain open.
4. Whether NRMS, Remote Monitoring Site 04, and Mara Venn are final names.
5. Whether the facility/research project remain unnamed.
6. Whether M-11–M-14 all ship.
7. Final recording-buffer and auto-archive behavior.
8. Exact queue durations and how active-play progress is shown.
9. Ending structure; no ending may explain the phenomenon or confirm AI responsibility.
10. Proposed IDs A-003–A-010 and A-020 need collision check.

## 10. Review checklist before implementation

- [ ] Every core artifact has discovery and recovery routes.
- [ ] Core artifacts remain accessible if found out of order.
- [ ] No live event, exact tuning, recording action, or early choice permanently blocks evidence.
- [ ] Shutdown summary and later records remain an unresolved contradiction.
- [ ] M-08/M-09 do not prove origin or common physical source.
- [ ] M-10B closes the assignment, not the mystery.
- [ ] Silent Site ends with a records discrepancy only.
- [ ] Provisional names, dates, times, frequencies, and sequence values remain visibly provisional.
- [ ] No code begins until design is sufficiently settled and implementation is explicitly authorized.
