# DEAD AIR — Android QA checklist

This checklist records test expectations, not a claim that every scenario has been verified on a phone.

## Automated checks

GitHub Actions runs these headless tests before APK export:

- `tests/investigator_workflow_test.gd`: saved investigator marks, note creation, working-hypothesis classification, source links, Notebook navigation, and delete/undo. It also checks unique event identifiers and distinct monitoring-cycle time bases.
- `tests/live_waterfall_test.gd`: live synthetic rows, receiver power gating, tuned SIG-0003 signal strength, telemetry, hold/resume, history retention across UI refresh, display gain, and clear.
- `tests/content_integrity_test.gd`: standalone evidence and clock-basis regression test; run manually until added to the CI job.

No automated headless test substitutes for a graphical Android-device inspection.

## Device smoke test

1. Start from an existing save. Confirm the regular Receiver remains accessible.
2. Turn receiver ON. Verify the scrolling synthetic waterfall generates lines continuously.
3. Tune to 14.070 MHz USB. Verify the readout identifies SIG-0003 as a curated catalog match.
4. Tune away from the authored channel. Verify the match clears and the trace resets.
5. Tap HOLD. Verify the existing display freezes; tap RESUME to restart it.
6. Use GAIN − / GAIN +. Verify visual brightness changes without modifying volume or evidence.
7. Tap CLEAR TRACE. Verify the waterfall empties, then refills while powered.
8. Open another tab and return. Verify the history survives an ordinary interface refresh.
9. Turn receiver OFF. Verify the display reports RX OFF and stops advancing.
10. Mark two signals, compare, and save an investigator working-hypothesis note.
11. Open each compared source from Notebook, delete the note, then use UNDO DELETE.
12. Restart the app. Verify marked signals and saved notes persist. Undo-last-delete is session-only.
13. Confirm the report, assignment, and archive records remain unchanged.

## Known open issue

The optional illustrated Graphite & Green receiver remains under investigation because the Android artwork-readiness gate previously rejected it. The standard receiver is the supported fallback. Do not treat illustrated-renderer visual verification as complete.

## Evidence guardrails

The live waterfall is **simulated**, not an RF receiver or microphone capture. It must not generate new authoritative evidence. In particular, the repeated NR-041 identifier and sequence in SIG-0004 and SIG-0005 do not prove a common transmitter. Their monitoring-cycle dates remain unknown, and the 18:00 / later communications timeline remains unresolved.
