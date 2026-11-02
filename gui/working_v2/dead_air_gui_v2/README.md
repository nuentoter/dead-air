# DEAD AIR — Receiver GUI v2

A playable *interface prototype* based on the locked 1672×941 receiver concept 05/06 hybrid.

## Run
Open `index.html` in Firefox or Chromium. No dependencies, server, or internet required. Resize the window; the image coordinate grid scales uniformly.

## Implemented
- Drag large tuning knob horizontally/upward; mouse wheel on knob; arrow keys tune at selected 10/100/1000/10000 Hz step.
- Drag small RF, AF, and squelch knobs vertically; keyboard arrows or mouse wheel also work.
- Bands HF/VHF/UHF, modes AM/LSB/USB/CW/FM, bandwidth cycling, simulated signal scan, display HOLD, waveform, RF waterfall, meter needle, AGC/NB toggles.
- Frequency-dependent, deterministic *synthetic* RF activity on a scrolling waterfall; varying readout based on tuned signal and gain.
- MARK adds timestamped station observations; RECORD logs recording start/end *metadata only*, **not audio**.
- Local private notes and observations in browser localStorage; export observation JSON.
- Distinct Archive, Timeline, Case Files, Map, and evidence navigation stub panels, with explicit statements where story integration remains pending.

## Visual assets
The original approved reference is retained as the static scenic/hardware base. Tunable dial/knobs have softened circular transparency masks in `assets/*_clean.png` and separate pointer rotations. Displays and dynamic overlays are redrawable via canvas/CSS. Some original text/illumination remains baked into the static master artwork; professional paint-over is still needed to produce a fully pristine empty chassis. Buttons are hit-tested over their photo-real artwork; lit state is a CSS glow to avoid replacing imagery with incoherent button textures.

## Simulation contract
This does **not** receive actual RF, record audio, decode transmissions, or simulate finished game story rules. Signals are synthetic, frequency linked and repeated. The true game receiver needs data-driven signal events connected to the evidence ledger and archival provenance; no automatic declaration that an anomaly is supernatural or true. Nothing in the prototype overwrites alleged sources or verified case material.

## Game integration
Move the static chassis to Godot `TextureRect`, each screen to `SubViewport` or `Control`/shader, and touch zones to `TextureButton`/`Control._gui_input`. Maintain 1672:941 aspect ratio letterboxing. Drive readouts from one authoritative ReceiverState model and use event signals for `frequency_changed`, `mode_changed`, `observation_marked`, and `recording_state_changed`. Keep saved observations distinct from archival evidence. Prototype implementation is web technology, not an exported Godot build.
