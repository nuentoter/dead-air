# DEAD AIR — UI reference build 01

Open `index.html` in a desktop browser. It is a self-contained, offline interactive **visual/layout prototype**, not a playable game or real SDR receiver. The physical chassis is based on the approved mockup and acts as the reference image. The central waterfall is generated procedurally, and transparent hit zones over the pictured controls respond to input. Some controls are only placeholders. The interface was designed for landscape displays; Android touch sizing and performance need validation in the eventual game build.

## Controls demonstrated

- Left column: receiver power, case files, evidence, recordings, chronology, map, archive, and local private notes.
- Large tuning knob: click to tune upward, or scroll mouse wheel over dial to tune both directions; arrow keys tune with current step size.
- Step switches: 10 kHz / 1 kHz / 100 Hz / 10 Hz.
- Mode switches: AM / FM / USB / LSB / CW (NFM through mode cycling).
- SCAN seeks next simulated frequency; HOLD freezes waterfall conceptual state; RECORD toggles a mock recording; MARK stores a provisional observation; ANALYZE shows measurement data.
- RF gain and squelch controls cycle simulated values, no calibrated receiver DSP yet.

## Proposed production parts and integration

| Component | Render approach | Data backing | Implementation priority |
|---|---|---|---|
| Radio metal chassis and bezel | Image asset or compact 9-slice | Cosmetic | P0 |
| Waterfall display | Dynamic generated texture / shader | transmission event schedule, signal level, frequency | P0 |
| Frequency readout | Text layer | active band/frequency, step | P0 |
| Tuning dial / step buttons | Hit areas, rotary/touch input | receiver tuning state | P0 |
| Band & modulation modes | Mechanical button states | HF/VHF/UHF; AM/FM/NFM/USB/LSB/CW | P0 |
| SCAN/SEEK, HOLD, RECORD, MARK | Interactive button states | event search, history buffer, recordings, observations | P0 |
| Signal meter, gain, squelch, bandwidth, noise reduction | Instrument overlay + controls | coherent signal model and DSP abstraction | P1 |
| Case navigation and receiver panel | Tabbed panel overlays | shift, assignments, signal IDs | P0 |
| Recordings and transcripts | Screen overlay | persistent event IDs and recovered content | P1 |
| Official archive and correction history | Search/filter overlay | immutable versioned records | P1 |
| Personal notes/bookmarks | Private local storage | player annotations | P1 |
| Reports and supervisor responses | Structured form overlay | evidence links, branch flags | P1 |
| Timeline and comparison | Separate tabs or overlay | event/created/received/archive dates | P2 |
| Map | Optional limited records/map panel | narrative locations | P2 |

## Canon corrections compared with the original visual

- **Blackwood** labels and paper notes in the photographic background are not DEAD AIR story canon. They are retained only in the *reference art* until their visual portions are repainted or replaced with Site 04 material. The functioning foreground display uses NRMS / Site 04 and NR-041 placeholders instead.
- The original image used 7.120 MHz as artistic example; final frequencies must match the standardized story-bible ledger.
- Signals in the actual game must be tied to one coherent simulated transmission model; this prototype generates a decorative waveform and a simple fixed seek list, so it does not yet meet that game-system requirement.
- Do not add fake glitches, supernatural interface lies, forced wait timers, or irreplaceable missed clues. The game documents explicitly prohibit these.

## Artwork extraction disclaimer

The PNG crops in `assets/` are **reference cutouts** from a flattened concept image, not clean isolated transparent sprites. Production should rebuild the chassis/knobs/buttons with controlled sprite boundaries, text-free faceplates, and separate illuminated states. Avoid scaling the entire 1672×941 image as a single texture in the final Android game until package-size testing is complete.

## Suggested Godot scene composition (once coding authorized)

`Workstation (Control)` → `Chassis (TextureRect)`, `ReceiverDisplay (Control)` → `Waterfall (TextureRect)`, `SpectrumOverlay`, `ReceiverHUD`, `FrequencyReadout`; `ControlHitAreas` → `TuningDial`, `BandButtons`, `ModeButtons`, `StepButtons`, `TransportButtons`, `SignalControls`; `NavigationPanel`; `DocumentOverlay`; `AudioController`; `SignalSimulation`; `ArchiveStore`; `SaveState`.

The project brief sets Android landscape-only, offline, Godot 4.x as a tentative engine, under-25-MB as a test target, and no implementation until the user explicitly requests coding. This prototype is a standalone design exploration and does not establish a production engine decision.
