# DEAD AIR — Implementation Status

**Current milestone:** First workstation prototype, v0.1.0  
**Status:** Godot 4.3 headless CI passes. On commit 2404e3c1ff9de5b02e299649b0dcc7cf66aa31ed, the arm64 debug APK exported at 24,330,645 bytes and the CI-signed release-mode APK at 22,966,724 bytes; both are below 25,000,000 bytes. APK manifest audit also passed on commit e4f2102934c5d109b8aa1b4761093772c592f0e1: both APKs have an explicit orientation entry and neither requests INTERNET or RECORD_AUDIO. Physical-device tests remain pending.

## Implemented
- Godot project configuration and main scene.
- Script-built landscape workstation UI with Receiver, Recordings, Archive, Notebook, Assignments, and Messages.
- Five authored opening signal events with stable IDs and readable transcripts.
- Core archive records M-02, M-05, M-06A (closed incident file 01-773 cover), M-07, M-08, M-09, M-10B.
- Local JSON save/load with schema version, temporary write, backup/restore during save replacement, and recovery-copy attempt for unreadable saves; automated malformed-save preservation is included in the self-test.
- Persistent text-size controls.
- Receiver power, frequency and mode state; authored event-match feedback; deterministic SEEK NEXT; manual-record provenance; a data-driven current-shift frequency/time plot with explicit in-plot time and frequency axis labels.
- Searchable archive, read-state tracking for required documents, notebook notes/source links, and player-selectable report citations persisted with the draft.
- Evidence-driven assignment progress: A-001/A-002/A-004/A-005 complete from their defined receiver/document actions (A-004 requires the M-06A cover, M-07 summary, and M-08 appendix); A-003 requires inspection of both NR-041 receptions and a separate comparison confirmation. Each assignment displays a persistent progress checklist based on the actual reviewed evidence and recorded state.
- Immutable report submissions/addenda and unresolved case status, displayed in a read-only report history with cited source IDs in Messages; each citation can open its retained signal event or archive document.
- Notebook entries display a readable title/metadata for each linked source and provide a direct open-source action; opening evidence never rewrites the note's interpretation.
- A-006 submission is blocked until M-02, M-05, M-07, M-08, and M-09 have been opened in the archive. All five are recoverable without live reception.
- Supervisor review appears after submission; M-10B remains hidden from archive until then.
- GitHub Actions checks project import, strict script parsing, main-scene startup, UI report flow, notebook source navigation, assignment checklist state, chronology consistency, report immutability/addenda, accessibility setting persistence, save/load behavior, Android export, APK size, manifest permissions, and orientation metadata.

## Verified on Godot 4.3
- Project import and script parsing passed.
- Main scene loaded and built the workstation shell in a headless smoke test.
- UI flow passed: navigate to A-006, verify early submission is blocked, open required records, submit a report, close A-006, and keep the case unresolved; read-only report citations and notebook evidence links open the expected source while preserving submitted text and note interpretation; assignment checklists update from OPEN to DONE as required records are reviewed.
- Integrity self-test passed: opening Signal IDs, NR-041, sequence 731904, 7.418 MHz consistency, M-07/M-08/M-09 timestamps, event retention, report immutability/addenda, text-size persistence, and save/load round trip.
- Successful workflow logs contained no parser/runtime error lines.

## Known simplifications
- Waterfall plot currently includes only SIG-0001–0003 from 08:00–08:30. Prior-cycle and next-shift NR-041 events are excluded because their calendar dates are unknown; this avoids implying a shared chronology.
- SEEK NEXT cycles through authored events; it is not a physical band scan.
- Frequency/mode are simulated; there is no RF processing, audio playback, SDR, or microphone use.
- All authored events are retained from the start so essential clues cannot be missed.
- No full eight-hour clock progression, queued archive retrieval, branch-heavy ending system, or complete Silent Site branch.
- Debug and CI-signed release-mode APK exports pass. Godot export success does not validate installation, runtime behavior, or visual usability on a physical phone.

## Not yet verified
- Physical-device installation/runtime behavior, touch layout, suspend/resume, and process-death recovery.
- Visual readability on a physical landscape phone.
- Save recovery under disk-full or forced process termination.
- Physical-device installation/runtime behavior, touch layout, suspend/resume, and process-death recovery.
- Full navigation testing on touch hardware.

## Next development steps
1. Extend automated interaction coverage around note/report draft recovery, assignment progression, and source selection.
2. Improve routine work-order progression while preserving free investigation and recoverable evidence.
3. Improve receiver interaction and selected-event clarity using deterministic authored data.
4. Add the next main-story content only after its evidence dependencies and recovery paths are implemented.
5. Keep physical-device validation marked as unverified; continue using CI and static/layout-oriented checks rather than treating owner testing as a prerequisite for development.
