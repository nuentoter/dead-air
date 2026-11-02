# DEAD AIR — Receiver UI Production Asset Pack v1

**Artwork master:** approved 1672×941 workstation hybrid (concepts 05 + 06).

## Deliverables
- `source/approved_master.png` retains the locked design reference.
- `source/chassis_mounted_base.png` is the receiver/desk mounting surface with covered control bays.
- `sprites/` contains transparent, individually positioned hardware cutouts: chassis control banks, knobs, signal meter, tuning dial, each physical button and navigation key.
- `sprites/button_*_{off,on,pressed}.png` contains precisely registered transparent state overlays.
- `sprites/*_indicator_{0,90,180,270}.png` provides knob indicator position overlays.
- `displays/*_blank.png` provides dark framed surfaces for dynamic waterfall, status, waveform, case monitor and frequency display.
- `atlas.json` includes each sprite's original pixel position, dimensions and suggested interaction hitbox.
- `previews/hardware_reassembled.png` checks visual alignment of separate layers.
- `previews/components.html` shows an interactive asset inventory without requiring external resources.

## Layer stack (back to front)
1. Chassis base (fixed texture)
2. Dynamic screen textures in the atlas screen rectangles (waterfall, frequency, status, case, waveform)
3. Hardware masks/sprites in their atlas locations
4. Button state overlays and knob pointer indicators
5. Text and modal overlays, rendered from game data (not embedded in raster)
6. Accessible clickable/touch areas matching hitboxes in the JSON

## Important limitations
This is an **extraction and layout-ready pack**, not a final hand-painted studio sprite set. Because the master is one flattened illustration, button labels are baked into hardware crops and some elements are imperfectly separable. The reassembled preview is the faithful composition check; remove/repaint fixed labels and improve cutout edges before final in-game production. The `chassis_mounted_base.png` is a masked mounting scaffold rather than a completely repainted blank radio body.

Suggested target is a Godot 4 `Control` scene with a 1672×941 root base scaled uniformly to landscape viewport. Apply percent positions from `atlas.json` for adaptive scaling. Drive waterfall pixels, frequency, meters and interface text from the same receiver simulation. Touch-drag on tuning dial, tap on mechanical switches, and configurable alternate swipe/button controls.

**Canon:** the mockup's Blackwood documents and 7.120 MHz are placeholders; game data should follow the DEAD AIR ledger.

## Working layered demo
Open `previews/layered_prototype.html` from a local server (for example `python -m http.server 8000` in pack directory, then `/previews/layered_prototype.html`). It loads the JSON atlas, draws independent hardware sprites, and uses the earlier prototype's interactive hotspots and simulated waterfall. Local file mode may block JSON fetch; use the server.
