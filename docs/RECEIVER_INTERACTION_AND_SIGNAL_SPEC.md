# DEAD AIR — Receiver Interaction & Signal Behavior Specification

*Working design specification, version 0.1. This remains the behavioral contract for the active prototype; current implementation is deliberately simplified and does not yet implement physical receiver behavior.*

## 1. Purpose and non-negotiable rules

The receiver is the player's primary instrument and the main recurring interaction surface. It should feel like a simplified, credible spectrum-monitoring tool without attempting to reproduce the full complexity of a real software-defined radio.

- The receiver is a deterministic simulation. It does not receive real radio, use the microphone, transmit, or connect to a network.
- A signal's authored event data drives its display, audio, classification, transcript, recording, and later archive representation.
- The interface stays stable and truthful. No fake glitches, hidden input changes, deceptive controls, fabricated scan stops, or supernatural display behavior.
- The player may miss the live moment, but must not permanently miss essential evidence. Important events are retained and can be reopened later with provenance preserved.
- Audio is atmosphere and an additional way to inspect content. Essential story information is always available as text or a readable record.
- Decode confidence is not source confidence. Correctly reading NR-041 does not establish where it came from or whether two receptions share a transmitter.
- The player is listen-only. No transmit, push-to-talk, contact initiation, or simulated ability to affect a real-world frequency.
- This is a design target, not a claim of validated engineering or final Android performance.

## 2. Receiver screen layout

Landscape-only. Use a compact but readable layout designed for touch.

### Persistent top/status strip

Display receiver power state (RX OFF / RX STARTING / RX READY), current band and tuned frequency, current mode, simulated clock and active-shift status, Signal ID when relevant, and a clear indicator when an event is live versus retained/archive playback.

The clock is an ordinary simulated clock. It never jumps for horror effect. Printed times in source documents remain as printed and are not silently normalized to the player clock.

### Spectrum/waterfall panel

- Frequency runs horizontally.
- Time runs vertically; newly simulated rows enter at the top and older rows scroll down.
- Brightness represents relative signal strength within the current display scale.
- The display shows a finite simplified frequency range around the current tuning region, not an unlimited real-world spectrum.
- A signal is represented consistently from event data: frequency position, occupied bandwidth, strength, start/end time, and modulation profile.
- Tuning or gain changes can change what the player sees, but do not rewrite the underlying event.
- A retained event can be shown as a historical view with its original reception metadata. Do not animate it as if it were currently being received.
- Waterfall history is a navigation and observation surface, not the only record of an event.

### Tuning/control panel

Always-visible band selectors:
- HF: 3–30 MHz
- VHF: 30–300 MHz
- UHF: 300 MHz–3 GHz

The simulation uses curated subranges within these broad bands; it need not expose every real frequency or imply full-band coverage.

Always-visible mode selectors: AM, FM, NFM, USB, LSB, CW.

Controls: frequency readout and fine-step left/right buttons; SEEK; gain; bandwidth; noise reduction; audio level/mute; Record/Stop; transcript/decoder access when relevant; open event details/archive.

Changing bands or modes must have an obvious visible effect on the current receiver state. Never silently change mode or frequency to make a clue easier to find.

### Signal detail panel

When a signal is selected or detected, show Signal ID if assigned, frequency and mode, relative strength, estimated signal type/classification and whether provisional, estimated bandwidth and SNR/interference indicators where useful, detection/classification/decode confidence as separate values or labels, live/retained state and event time, and appropriate actions: tune, listen, record, decode, open transcript, compare, bookmark, archive.

Avoid false precision. Technical measurements are simplified simulated values. Label estimates as estimates.

## 3. Receiver power and startup

### RX OFF

- The screen shows the receiver as powered off.
- No live receiver audio is emitted.
- The player may still access archive, notebook, assignments, settings, and saved records.
- Turning the receiver off does not delete an event or cancel a queued assignment.

### Power on

1. Show RX STARTING.
2. Run a short, consistent startup sequence.
3. Show RX READY and tune to the current saved frequency or the configured opening-shift time standard at `10.000 MHz AM`.
4. Start adding simulated waterfall rows from the current active-play clock.
5. Resume eligible active-play queue progression.

Startup is ordinary UI behavior, never a vehicle for fake faults or misleading results. If the player leaves the receiver screen during startup, startup completes normally.

## 4. Tuning and touch behavior

- Tap a visible signal trace to tune to its center frequency and open its compact detail panel.
- Drag horizontally across the waterfall to explore frequency. The frequency readout follows the selected position.
- Fine-step controls move the tuned frequency by a clearly indicated increment appropriate to the selected range.
- A long press may open a context panel, but must not be the only way to access an important action.
- The currently tuned frequency is visually distinct from signal traces.
- If traces are too narrow or crowded to tap accurately, provide a nearby list of detected events in the current view.
- The player can open any retained event from the archive without reproducing its original tuning gesture.

Touching a signal does not guarantee that the current mode can decode it. Explain a mismatch plainly (for example, “Signal detected; current mode is not suitable for decoding this event”). The player can change modes without losing the event record.

## 5. SEEK and scanning

### Single SEEK

When the player presses SEEK:
1. Scan forward from the current tuned frequency within the current curated range.
2. Evaluate candidate signals against the current detection threshold and receiver settings.
3. Stop at the first qualifying candidate.
4. Tune to the candidate and show its detail panel.
5. If no candidate qualifies before the range ends, wrap to the beginning and continue until the range has been evaluated once.
6. If no candidate qualifies in the evaluated range, stop at the defined end/current wrap position and show “No qualifying signal found in this range.” Do not create a signal, event, or archive entry.

SEEK does not have to stop at every visible trace. Eligibility is determined by event presence, timing, signal strength, mode/band conditions, and the player's current detection threshold. Explain the rule in onboarding; do not make it feel random.

Pressing SEEK again continues scanning beyond the current candidate rather than repeatedly stopping on the same event, unless no other candidate qualifies.

### Continuous SEEK

- Long-press SEEK to enable continuous scan.
- Stop at each qualifying candidate for a short, consistent inspection interval.
- Show a clear SCANNING / STOPPED status.
- The player can stop continuous scan at any time.
- Reaching the range end wraps to the start.
- Continuous scan must not be required to discover core story evidence.

### Detection threshold

Gain and scan threshold interact:
- Raising gain can make weak signals more visible/audible, but increases noise or distortion.
- A higher detection threshold reduces stops on weak candidates.
- A lower threshold can produce more stops, including ordinary low-quality traffic.
- The exact numerical implementation is an engineering choice; the player-facing rule must remain consistent.
- If no qualifying event exists, SEEK reports none. It never invents a stop to fill time.

## 6. Gain, bandwidth, and noise reduction

### Gain
- Affects the rendered received signal level and perceived noise/distortion.
- Does not alter the authored event's original strength or archive metadata.
- Excessive gain may make a weak signal more audible while reducing clarity through simulated distortion.
- If gain is changed during an event, show the current setting and reflect it consistently in audio and display.

### Bandwidth
- Affects the portion of a signal the receiver passes to the player.
- Narrow bandwidth may reduce adjacent interference and improve intelligibility for some signals, but can cut modulation detail or distort content.
- Wide bandwidth may preserve detail but admit more noise or neighboring traffic.
- Do not make a single bandwidth setting universally correct.

### Noise reduction
- Reduces some simulated static/noise.
- Can remove faint detail or artifacts that matter to a careful comparison.
- Does not delete or rewrite the authored transcript.
- A note in the analysis panel may state that processing can affect audible detail.

These controls create understandable trade-offs, not a hidden skill check. If a clue depends on a weak audible detail, preserve a recoverable alternate route through replay, transcript, retained event analysis, or a later worksheet.

## 7. Modes and decoding

Modes are simplified receiver interpretations. A mismatch should produce a plausible degraded result rather than arbitrary failure.

- AM: suitable for authored AM voice/broadcast events.
- FM: suitable for wider-band FM-style traffic in the curated simulation.
- NFM: suitable for narrowband voice/utility traffic.
- USB / LSB: sideband modes for authored HF voice or data-like content.
- CW: suitable for keyed tone patterns and identifier/sequence transmissions.

The same authored event may sound different across modes, but its underlying canonical content remains unchanged. The player may hear noise or an unintelligible result when mismatched. The event record distinguishes “not decoded under these settings” from “no content exists.”

### CW decoder

Controls: decoder on/off, adjustable tone pitch, adjustable decoding speed, replay, and manual listening.

- Preserve canonical event content separately from the player's current decode attempt.
- Display the best available decode and its confidence.
- If the identifier is high-confidence but a numeric sequence is uncertain, show separate confidence for those fields.
- Do not silently replace an earlier decode when a later setting produces a different interpretation. Save later attempts or revisions as linked analysis, retaining the prior result.
- The decoder is deterministic and authored, not real machine learning.
- Manual listening remains possible; no critical evidence depends on perfect Morse skill or exact speed settings.

## 8. Audio and text transcript behavior

- Audio is generated or assembled from authored event content and simple procedural effects.
- No microphone input, cloud speech recognition, online AI, or user speech is required.
- A transcript can be opened before, during, or after replay when one exists.
- Transcripts may contain uncertainty markers such as [unclear], [possible repeat], or [sequence uncertain].
- The uncertainty belongs to the reception/decoding record; it must not imply that canonical content has been secretly changed.
- A later correction or improved decode creates a linked version/analysis record.
- Always offer a readable content view for essential narrative information.
- Audio playback controls include play/pause, restart, and a sensible seek/replay control when applicable.
- Audio volume and mute are separate from receiver gain.
- If sound is disabled or the app is interrupted, the event remains available for later review.

## 9. Recording behavior

### Manual recording

- Press RECORD to start recording the current live receiver output.
- Show a clear recording indicator and elapsed simulated recording duration.
- Press STOP to end and save the recording.
- If the player changes frequency or mode while recording, reflect what the receiver actually captured; do not imply it followed a signal automatically.
- If the player switches away from the receiver, pauses, or closes the app, save a valid recording segment up to the interruption and explain that the segment ended. Do not corrupt or discard it.
- A short recording is still valid. Duration may affect how much ordinary audio it contains, but must not determine permanent access to a core clue.

### Recording provenance

Every saved recording states recording ID, start/end time as captured by the simulation, frequency, mode and relevant receiver settings, linked Signal ID(s) if any, whether it was manually recorded / automatically retained / recovered from archive, transcript/decode status and confidence, and any processing or later analysis links.

Do not claim that a player manually recorded an event if they missed it. Use “system-retained event; not manually recorded during active monitoring.”

### Automatic event retention

The simulation automatically retains key event metadata and required narrative content, including core-story events. This is an evidence-recovery safeguard, not a claim that the station records every second of every band.

When the player misses a live transmission:
- Preserve a retained event summary and authored content for essential events.
- Preserve original reception time, frequency, mode, and event ID.
- Mark provenance as system-retained.
- Make the event available from the receiver event list and archive.
- Do not create a fake manual recording or pretend the player heard it live.
- Optional ordinary traffic may be represented by activity totals or short summaries when the receiver is off; full detailed background recordings are not required.

## 10. Signal event model and consistency

Each authored transmission event should provide, at minimum: stable event key; Signal ID assigned when it becomes a player-visible retained record; frequency and occupied bandwidth; mode/modulation profile; simulated start time and duration; relative strength and propagation/fading profile; authored canonical content or nonverbal signal pattern; recurrence rules if any; detectability conditions; transcript/decode variants and confidence by field; story-criticality and retention policy; allowed receiver-mode interpretations; provenance and relationships to earlier/later events.

All visual and textual representations derive from this event data. Do not author independent contradictory values in waterfall, audio, transcript, and archive.

A recurring event is not necessarily the same transmission or transmitter. Matching identifiers/content may support comparison, but the interface must not infer a common physical source unless a separate authored record establishes that fact.

## 11. Signal ID lifecycle and corrections

- Assign a stable Signal ID when an event becomes a retained player-visible event.
- Use that ID across receiver detail, recording, transcript, archive, notebook links, and reports.
- If new evidence changes a provisional classification, add a new classification version or correction note.
- Keep original classification, timestamp, and source record accessible.
- Do not reassign a Signal ID to a different event.
- Signal ID sequence is administrative, not a clue unless a story document explicitly establishes its meaning.
- Working ID format: `SIG-####`, allocated in story-event order and never reassigned. Initial allocation: `SIG-0001` time standard; `SIG-0002` routine traffic A; `SIG-0003` routine traffic B; `SIG-0004` first NR-041 reception; `SIG-0005` NR-041 recurrence. `SIG-0042` is not assigned in the opening sequence.

## 12. Event list and archive recovery

The receiver event list should support live/currently detectable events, recent events, retained events not manually recorded, bookmarked events, events linked to current assignments, and direct open-in-archive action.

Archive filters should include frequency, mode, time/date, Signal ID, classification, transcript availability, recording availability, and provenance. Search may use identifier text such as NR-041 or document/reference IDs where indexed.

Core-story events remain available even if the player did not tune live, SEEK passed it, the receiver was off, recording stopped early, the player used an unsuitable mode, the app was closed/interrupted, or related documents were discovered out of order.

Recovery preserves the distinction between live reception, manual recording, and system-retained event. The player may miss context or atmosphere, but not essential evidence.

## 13. Comparison and analysis

A comparison view places two or more retained events side by side using their original metadata.

Possible fields: identifier/transcript; frequency and mode; reception time as recorded; relative strength and reception quality; pattern/timing summary; sequence decode and confidence; estimated bandwidth/SNR; recording and provenance type; source field, which remains “not established” unless an independent source record supports more.

Rules:
- Never normalize times silently.
- Never auto-conclude that matching identifiers prove a common transmitter.
- Make uncertainty visible without overwhelming the screen.
- Preserve player observations as notebook notes or a new report.
- Later comparisons are linked records; they do not modify original events.
- A player's hypothesis can be stored, but distinguish it from measured/recorded fields.

## 14. Time, interruptions, and save behavior

- Simulated time advances during active receiver use, active assignments, and queued work as specified in GAME_DESIGN.md.
- Simulated time does not advance while idle or while the app is closed.
- The player can close the app at any point without losing evidence or being punished.
- Save receiver settings, active shift, tuning state, presets, notebook, archive state, reports, queue state, and recording segments at sensible checkpoints.
- If Android suspends or kills the app, recover to a stable screen and state what was saved.
- Never imply the receiver was actively monitoring while the app was closed unless the design explicitly labels resulting data as a coarse simulation summary rather than a detailed recording.
- No real-world waiting or time-sensitive window is required for a clue.

## 15. Presets

- All presets appear in one list.
- Each preset stores a name, frequency, and mode.
- Selecting a preset tunes frequency and mode and selects the appropriate band.
- Story presets may be added automatically with a visible explanation.
- Presets do not guarantee that a signal is currently active.
- If no signal is present at a preset, the receiver shows ordinary current conditions; it does not play a saved clue as if live.
- Player-created preset names are local notes, not canonical event metadata.

## 16. Onboarding sequence

Teach receiver operations in context during the opening shift:
1. Power on RX and observe the consistent startup/time-standard behavior.
2. Identify the frequency axis and time-scrolling waterfall.
3. Tap an ordinary signal and inspect its details.
4. Change mode and notice how interpretation can change.
5. Use SEEK and understand the “no qualifying signal” result.
6. Adjust gain or bandwidth to improve a reception while noting the trade-off.
7. Open a transcript and compare it with audio.
8. Record an ordinary signal and inspect the saved provenance.
9. Open a retained event and learn the difference between manual recording and system retention.
10. Submit the routine identifier report and find its archive entry.

Do not front-load a long technical tutorial. Provide short contextual hints, an optional help panel, and a glossary. The player should be able to dismiss hints and return to them later.

## 17. Failure states and messages

Use calm, specific messages:
- “No qualifying signal found in this range.”
- “Signal detected; current mode is not suitable for decoding this event.”
- “Reception is too weak for a confident decode. The retained event remains available.”
- “Recording saved with a shorter capture duration because receiver activity ended.”
- “This event was retained automatically; it was not manually recorded during active monitoring.”
- “Processing may reduce audible detail. Compare the original reception or transcript.”
- “The source is not established by the available reception metadata.”

Avoid fake hardware failures, random deletion/corruption, punishment for a missed signal, “signal lost forever” for essential evidence, unexplained changes to event IDs/timestamps, or messages that state/imply the supernatural explanation as fact.

## 18. Accessibility and Android constraints

- Touch targets should be comfortable on a landscape phone screen.
- Text remains readable at typical phone scale; provide a text-size setting if practical.
- Do not encode signal strength, status, or confidence by color alone.
- Use distinct labels/icons alongside green/amber colors.
- All critical actions have visible labels and do not depend on long-press gestures alone.
- Provide audio mute and volume controls.
- Keep the receiver view responsive; do not require expensive waveform effects, 3D, or large media assets.
- Package-size target remains under 25 MB but must be measured in a real export. This specification does not validate the target.

## 19. Decisions still open

The following must be tested or locked during design/prototyping: exact curated frequency subranges and step sizes; number of visible signal types and mapping to six modes; numerical model for gain, noise, bandwidth, SNR and detection threshold; waterfall history depth and update rate; audio synthesis approach and compressed asset budget; whether the optional spectrum plot ships in the first version; Signal ID allocation/persistence rules; exact Android lifecycle/save checkpoints; exact screen geometry and minimum supported display dimensions; final Godot version, Android export size and performance.

Do not invent precise values for these in story documents before the design decision is made.

## 20. Prototype acceptance criteria

The receiver design is ready for a prototype when the team can demonstrate that:
1. A signal's event data drives display, audio, transcript, classification, and archive consistently.
2. SEEK never invents a signal and clearly reports when none qualifies.
3. A mismatched mode can produce a degraded result without destroying evidence.
4. Gain, bandwidth, and noise reduction have understandable, consistent trade-offs.
5. A core event can be recovered if missed live or if recording is interrupted.
6. Provenance distinguishes manual recording from system retention.
7. Re-decoding creates linked analysis without silently replacing prior evidence.
8. Time and timestamps are not silently normalized.
9. Closing/reopening the app preserves progress and imposes no real-world penalty.
10. No core clue depends on exact tuning, recording duration, audio-only content, or a live time window.
11. Comparison views distinguish observations from hypotheses and do not infer source identity from an identifier alone.
12. The UI remains stable and truthful throughout all receiver states.

This specification defines intended behavior. The current prototype implements only a bounded deterministic subset; use the acceptance criteria to guide verification and subsequent increments.


## 21. Current prototype mapping

The first implementation deliberately covers only a deterministic subset:
- Receiver power, frequency, and mode are saved locally.
- The current tuning displays authored event matches only when frequency is within 0.0005 MHz and mode matches exactly.
- SEEK NEXT moves to the next authored event in catalog order and tunes to its metadata. It is not a physical scan.
- All five authored events are automatically retained from the start. Manual recording adds a separate provenance marker.
- The current plot is data-driven for current-shift events SIG-0001–0003 only, mapped across 0–15 MHz and 08:00–08:30. Prior-cycle and next-shift NR-041 events are excluded because their calendar dates are unknown; the UI explicitly labels this limit.
- Event transcripts and source limitations are always visible as text.

These simplifications must remain honestly labelled until replaced and tested.


## Local event audio rendering (prototype)
- PLAY SIGNAL AUDIO uses authored event metadata to select a deterministic local rendering: synthetic voice for voice traffic, keyed Morse for CW identifier/sequence, a monitor carrier for the reference event, and a short FSK-like burst for the incomplete data event.
- READ TEXT is a separate optional accessibility rendering of the visible transcript; it is never presented as source audio.
- STOP AUDIO halts playback. The shared audio mute preference gates all local playback.
- Spoken readout speed is adjustable from 0.75× to 1.25× and saved locally.
- These renderings are not evidence of a physical transmitter, common origin, or hidden payload. Transcripts and provenance remain authoritative.
