# DEAD AIR — Implementation Test Checklist

Mark only tests actually performed; “not run” is not a pass.

## Environment
- Godot version:
- OS/editor:
- Device or emulator:
- Export template version:
- Test date:
- Commit tested:

## Static project checks
- [ ] Project opens without missing resources.
- [ ] Main scene loads.
- [ ] No parser errors.
- [ ] No startup runtime errors.
- [ ] Landscape orientation requested by project configuration.

## Core interaction
- [ ] Navigate all six sections.
- [ ] Verify A-001/A-002/A-004/A-005 completion follows their evidence actions.
- [ ] Verify A-003 requires both receptions and explicit comparison confirmation.
- [ ] Power receiver on/off.
- [ ] Change frequency and mode.
- [ ] Waterfall maps current-shift event frequencies horizontally and time vertically; it excludes prior/next-shift records with unknown dates.
- [ ] SEEK selects only authored events.
- [ ] No-match SEEK gives truthful message.
- [ ] Event details/transcript match catalog.
- [ ] Manual-record status differs from automatic retention.
- [ ] Receiver off does not remove essential archive events.
- [ ] Archive search returns expected records and honest no-result messages.
- [ ] Notebook note can be added/removed without losing other notes.
- [ ] Report draft can be edited/submitted.
- [ ] Submitted report remains immutable.
- [ ] Report source links can be selected/deselected and are preserved in the submitted report.
- [ ] Supervisor response appears after submission.
- [ ] Submitted report history displays the exact body, recommendation, citation IDs, version, and unresolved status without editing the saved submission.
- [ ] Assignment closes; case thread remains unresolved.

## Persistence and recovery
- [ ] Fresh install creates usable defaults.
- [ ] Save/load preserves notes, reports, receiver settings, navigation.
- [ ] Automated malformed-save test preserves the original bytes in a recovery copy and restores the valid test save afterward.
- [ ] Invalid save gives clear fallback and does not crash.
- [ ] Suspend/resume does not advance simulated time.
- [ ] Missed live events remain in archive.
- [ ] Essential evidence works without audio.

## Canon integrity
- [ ] M-07 shutdown claim remains 18:00.
- [ ] M-08 entries remain 18:17/18:19/18:23.
- [ ] M-09 entries remain 18:19/18:21/18:23.
- [ ] Clock/source uncertainty is visible.
- [ ] Sequence 731904 meaning remains unknown.
- [ ] No source attribution inferred from repeated IDs/sequences.
- [ ] No fake UI malfunction appears.

## Android release checks
- [ ] Physical device or emulator launch.
- [ ] Touch targets usable in landscape.
- [ ] Text legible at default scale.
- [ ] Back navigation does not discard work.
- [ ] No microphone/network permission requested.
- [ ] APK/AAB size measured and recorded.
- [ ] App survives process death/reload.
- [ ] Offline launch works.
