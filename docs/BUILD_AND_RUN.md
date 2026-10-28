# DEAD AIR — Build & Run Guide

## Current baseline
The repository's first workstation prototype is configured for Godot 4.x. The headless CI workflow uses Godot 4.3 and currently checks script parsing, main-scene startup, core chronology, retained event IDs, report submission, unresolved case status, and save/load persistence.

This is a desktop-testable prototype, not yet an Android release. A minimal arm64 Android debug export preset and a GitHub Actions APK-export workflow are committed. SDK paths and release signing credentials remain machine-specific; the workflow uses debug signing and is still being validated.

## Run locally
1. Install Godot 4.3 or a compatible later Godot 4 release.
2. Download or clone the repository: https://github.com/nuentoter/dead-air
3. Open the repository's project.godot in Godot Project Manager.
4. Run the main scene (F6) or the project (F5).
5. Navigate the six work areas. All story evidence is text-accessible and simulated.

## Headless checks
Run these from the repository root:

```sh
godot --headless --path . --editor --quit
godot --headless --path . -s res://tests/parse_project.gd
godot --headless --path . -s res://tests/ui_flow_test.gd
godot --headless --path . -s res://tests/self_test.gd
godot --headless --path . --quit-after 3
```

The UI-flow and self-tests write test reports into Godot's user:// save for that environment. Prefer a clean test profile when checking a personal save. GitHub Actions runs in a disposable runner.

## Android export (not yet verified)
1. Install the Android SDK and JDK supported by the chosen Godot version.
2. Install matching Godot export templates.
3. Configure Android SDK/JDK paths in Godot Editor Settings.
4. The repository includes a debug Android preset. For a local export, verify SDK paths in Editor Settings and adjust the preset if your device/API requirements differ.
5. Export a debug APK and test it in landscape on a device/emulator. The Android Actions workflow builds a debug APK and a CI-signed release APK, measures both, and publishes them as a temporary downloadable artifact when the workflow succeeds. The CI release key is disposable and must never be used for a public store release. The Android Actions workflow will publish a temporary downloadable artifact when it succeeds.
6. Test suspend/resume, process death, offline launch, readable text, and touch targets.
7. Measure the actual package size. Do not claim the under-25-MB goal is met until measured.

Do not commit signing keys, passwords, local SDK paths, or private export credentials. The local export preset is ignored by .gitignore.

## Troubleshooting
- If the editor reports a script parse error, run parse_project.gd and inspect the first reported file/line.
- If a test fails because of existing user:// state, run it in a clean Godot user-data environment; do not delete a user's real save just to make a test pass.
- If the main scene opens but controls are too small, capture the target viewport dimensions and update the layout against the interface spec.
- If Android export is unavailable, desktop headless success does not imply Android success.
