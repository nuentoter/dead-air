# DEAD AIR — GUI integration and usability audit
**Audit:** 2026-11-01 (repository revision after GUI v2 upload)  
**Reviewed:** `gui/working_v2/dead_air_gui_v2/index.html`, v2 README, production atlas, Godot project configuration, main game scripts, and GitHub Actions results.

## Verdict

**GUI v2 is a coherent standalone browser *concept/prototype*, not the Godot runtime GUI.** Its image and overlay files were committed under `gui/`; the Godot launch scene remains `res://scenes/main.tscn` using `scripts/main.gd`. None of the new visual layers are connected to that game scene by this artwork commit. The Android APK is therefore not a test of the new illustrated interface.

| Area | Status | Basis |
|---|---|---|
| Art pack and browser references | Static validation passes | `tests/gui_smoke.py` checks referenced PNG files, atlas dimensions, inline JavaScript syntax, and browser viewport |
| Browser receiver controls | Prototype functional, partially simulated | Drag/wheel/keyboard tuner; mode, band, filter, scan, hold and observation metadata controls |
| Touch access | Improved; **device testing required** | Visible 44-pixel quick-controls launcher and modal alternatives for cramped physical hit zones |
| Narrative/canon linkage | Not integrated | Browser RF list is a deterministic demo, not Godot `SIG-0001`–`SIG-0005` and `M-xx` records |
| Recording integration | Separate implementations | Browser RECORD saves metadata only. Godot captures locally generated monitor PCM. They do not share state or capture the authored transmission audio |
| Persistence | Separate implementations | Browser localStorage is independent of Godot `user://dead_air_save.json` |
| Godot UI and report flow | Headless tests pass on fixed workflow | No proof of phone touch layout, visibility or real audio performance |
| Android illustrated UI | **Not present** | Art is not imported into an Android Godot scene |
| Package budget | Must re-measure after importing artwork | Earlier APK size measurements did not include new art assets |

## Confirmed integration and usability risks

1. **Two independent interfaces.** Do not regard the web prototype as a replacement for the game interface until the visual receiver uses the same authoritative Godot receiver state, event IDs, archive, assignments, reports, and saves.
2. **Touch targets in art are too small.** At a 1280×720 landscape viewport, a 22-pixel-high photographed mode button scales to roughly **17 screen pixels**, below a sensible touch target. A large-touch control panel is now supplied in browser v2. Production Godot must make corresponding controls accessible without requiring precise taps on photographs.
3. **Frequency example vs story canon.** The illustrated starter frequency remains 7.120 MHz, a visual example, while story NR-041 is **7.418 MHz CW**. The browser synthetic band now includes 7.418 MHz and aligns its demo indicator to that channel; an indicator is not a decoded or verified story event.
4. **Asset manifest scope.** `gui/working_v2/dead_air_gui_v2/atlas.json` is copied production-pack metadata. Its relative `hardware/` and `sprites/` paths refer to the asset pack under `gui/production_assets_v1/dead_air_production_assets/`, **not** the v2 browser directory. The browser itself uses `assets/` and does not load that atlas. Do not treat the v2 manifest as directly loadable from its own folder without path remapping.
5. **Some photographic text is baked in.** The reference image contains narrative/text details not suitable for canonical screens, including Blackwood elements identified in the original GUI README. Retouch and replace any such text before final game integration.
6. **Partial control behaviors.** Browser HISTORY/PEAK/AVERAGE display options are visual demonstrations rather than complete signal-processing implementations; AGC/NB are toggles without equivalent receiver DSP; the browser has no received RF or audio recording. This must remain clear to testers.
7. **UI readability.** The status strip, site panel and mode labels use small `clamp()` font sizes. Verify at 1280×720 and at the smallest intended landscape device; don't infer usability from desktop scaling.
8. **Input behavior.** Browser v2 was patched so arrow keys on focused gain/squelch sliders no longer also retune the receiver. Keyboard focus and modal/quick-control interactions still need real browser and touch-device testing.
9. **Older CI error fixed.** The Godot integrity test previously failed because a legacy-settings fixture wrote invalid JSON indentation. The fixture was corrected and the Godot workflow returned success, but an actual device regression pass is still necessary.

## Production integration requirements (recommended priority)

**P0 — Link model and interface:** Build a Godot illustrated `Workstation` scene using the approved layers as presentation only. Both the original accessible controls and illustrated physical controls must call the existing `DeadAirGameState` API. Authoritative receiver state and selected events must be displayed in both routes without duplicated game logic.

**P0 — Complete real report and evidence navigation:** Case files, recordings, archive, notebook, assignments, messages, and report submissions must open the real Godot panels; remove browser placeholder narratives rather than duplicating them.

**P0 — Receiver capture provenance:** Ensure illustrated RECORD maps to the intended Godot synthetic monitor recorder, while MARK creates observational metadata; never label a browser metadata log as PCM or an institutional retained artifact as player-captured RF.

**P1 — Small-screen usability:** Support Android landscape letterboxing and a minimum usable tap region. Provide accessible alternative buttons / scalable text for controls too small to hit on the artwork.

**P1 — Asset polish:** Clean source-baked text, verify contrast/legibility and real button states, avoid storing multiple 1672×941 full-frame copies in the Android package.

**P1 — Test:** Godot UI navigation tests, Android landscape screenshot review, touch/drag/wheel alternatives, pause/resume and capture continuity, offline startup, APK measurement and orientation/permissions audit.

## Review checklist before claiming integration complete
- [ ] Start the Android Godot app and see the illustrated workstation, not only the script-built previous UI.
- [ ] Change tuning/mode in graphic controls and observe authoritative receiver state everywhere.
- [ ] Tune to a retained NR-041 event; confirm `SIG-0004`/`SIG-0005` details are sourced from the game catalog, not demo band arrays.
- [ ] Record, stop, retune and reopen a synthetic monitor clip; confirm original institution-sourced evidence remains separate.
- [ ] Open archive evidence from its related links and preserve chronology contradictions.
- [ ] Submit A-006 with cited sources through the graphical interface; preserve report history and the unresolved ending.
- [ ] Use every essential action on a small landscape phone without precision taps.
- [ ] Re-run tests, export an updated Android APK containing the art, and measure file size.

**Note:** Static code/asset review and CI checks were performed. A screenshot-based browser visual inspection and a physical Android touch review were not performed in this audit; those remain explicit validation steps.
