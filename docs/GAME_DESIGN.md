# DEAD AIR — Game Design Overview

*Consolidated from the working Game Design Document, version 0.1, 27 October 2026.*

## 1. Experience

DEAD AIR is a slow-burn, procedural, evidence-driven radio horror game for Android. The player is a technician at a remote civilian spectrum-monitoring site. They tune a simulated receiver, listen to ordinary traffic, record and decode transmissions, complete routine assignments, and investigate discrepancies in official records.

The screen stays stable and reliable. The horror emerges through transcripts, conflicting timestamps, missing records, and professional messages that close questions without answering them.

**Platform:** Android, landscape-only, offline.  
**Package target:** under 25 MB, subject to prototype/export measurement.  
**Engine direction:** Godot 4.x with GDScript proposed; not yet tested.  
**Commercial idea:** USD $0.99 is only a possibility, not a locked decision.

## 2. Design Pillars

- **Procedural realism:** routine monitoring, assignments, records, and plausible technical limits.
- **Unknowability:** never identify the phenomenon beyond the connection, its intentions, or AI responsibility.
- **Evidence over spectacle:** investigate through recordings, transcripts, archive searches, reports, and comparisons.
- **Stable interface:** no fake glitches, supernatural clock behavior, arbitrary queue failures, or visual lies.
- **Player autonomy:** no real-world waiting, expiring tasks, streaks, quotas, or penalties for closing the app.
- **Recoverability:** essential clues cannot be permanently missed.
- **Small production footprint:** no 3D, walkable world, large voice packs, online services, real SDR hardware, or elaborate animation.
- **Anonymous observer:** radio operators have their own lives and do not recognize the player or have relationship meters.
- **Textual accessibility:** audio is atmosphere plus information; meaningful content is available as text.

## 3. Role and Premise

The player works for the fictional **National Radio Monitoring Service (NRMS)** at **Remote Monitoring Site 04**. These institutional names are current working canon v0.2. Their ordinary duties include checking spectrum activity, verifying identifiers, investigating interference, logging unauthorized transmissions, and forwarding reports. They are not a chosen one, secret agent, or physicist.

A government research project combined advanced AI with experimental particle-physics research to model phenomena outside conventional understanding. A serious incident occurred, and later government records contradict one another. Low-bandwidth radio networks and numbers-station-like transmissions served as fallback communications when digital networks were considered unreliable or compromised. Site 04 captures structured transmissions associated with a project official records say did not exist.

The true sequence of events remains unresolved. The game does not confirm whether the experimental AI caused the incident or what lies beyond the connection.

## 4. Visual and Sound Direction

- Dark charcoal/black interface, green phosphor traces and text, restrained amber warnings, crisp grid lines.
- Dense receiver view inspired by SDR++ waterfall/spectrum analysis.
- Landscape-only interface with touch-friendly controls.
- Waterfall frequency axis runs horizontally; time runs vertically as new rows arrive and history scrolls. Brightness represents signal strength.
- A small spectrum plot is optional if lightweight.
- Procedural sound generation: tones, simple music patterns, synthetic character voices, static, fading, filtering, and narrowband distortion.
- Avoid large audio libraries and elaborate equipment animation.

## 5. Receiver Controls

- Always-visible band buttons: HF (3–30 MHz), VHF (30–300 MHz), UHF (300 MHz–3 GHz). Each band uses a simplified subset of frequencies.
- Always-visible modes: AM, FM, NFM, USB, LSB, CW.
- Drag across the waterfall to explore; tap a signal to tune; left/right for fine steps.
- **SEEK** scans forward and stops at a qualifying signal. Long-press scans continuously, stopping at qualifying signals. Press SEEK again to continue beyond the current signal. Scanning wraps at the range end.
- Detection threshold relates to gain. If no qualifying signal exists, SEEK must not invent a stop or event.
- Bandwidth can isolate a signal but cut detail. Gain boosts weak signals while increasing noise/distortion. Noise reduction can suppress static but lose detail.
- CW decoder has adjustable speed and tone; manual listening remains available.
- Compact signal panel shows frequency, strength, estimated type, confidence, and actions. Full receiver view adds audio, transcript, decoding, recording, and analysis.
- Each detected event has a persistent Signal ID (e.g. SIG-0042). Later evidence may improve the provisional description without overwriting prior classifications.
- Presets share one list. Each stores frequency, mode, and player-assigned name; selecting one changes band/frequency/mode. Story presets may be added automatically.

## 6. Simulated Radio World

The receiver is a coherent simulation, not a real SDR. Each transmission event has frequency, signal type, start time, duration, strength, content, and recurrence. Those parameters must drive waterfall shape, audio, classification, and transcript quality consistently.

Traffic varies by simulated time, band, and propagation conditions. Most traffic is ordinary; unusual transmissions are rare. Scheduled programs, time signals, and beacons coexist with recurring habits and variable everyday traffic. Operators never recognize or remember the player.

Voice traffic includes short snippets, occasional longer conversations, and stories distributed across transmissions. Story content remains recoverable. When the receiver is off, simulated time continues, but background monitoring saves activity totals and unusual-event summaries—not full recordings or detailed timestamped logs.

Classification may be wrong because of weak/noisy signals. Errors should be technically plausible and recoverable through tuning or alternate recordings. Detection, classification, and decoding confidence are deterministic game rules, not real machine learning. Show supporting details such as estimated bandwidth, SNR, and interference. The player is listen-only: no transmitting, push-to-talk, or initiating contacts.

## 7. Audio, Transcription, and Recordings

The game authors the underlying text/content of every transmission. Audio generation and transcript corruption are simulated from that content; no online AI or real speech recognition is required. Audio is never the only route to essential information.

## 8. Time, Shifts, and Requests

The hybrid simulated clock advances during active work, queued requests, and brief receiver monitoring. It does not advance while the player is idle or the app is closed.

A standard shift is eight in-game hours. Notify the player at eight hours; flexible overtime is allowed and recorded without penalty. The player can end early, continue overtime, or close the app mid-shift. Progress saves.

Illustrative procedural queue delays:
- Automated archive: 1–5 in-game minutes.
- Supervisor review: 10–30 in-game minutes.
- Cross-station comparison: 30–90 in-game minutes.
- Restricted file: 1–3 in-game hours.

Queues progress through simulated active work; no real-world waiting or essential progress locked behind idle time. Optional break flavor includes coffee, notices, weather, and private notes. No hunger/fatigue system. Multiple assignments may be active at once, with no quotas, expiration, or deadlines. Statuses: OPEN, IN PROGRESS, AWAITING REVIEW, CLOSED.

## 9. Archive, Notebook, Reports, and Choices

The official archive automatically saves recordings, available transcripts, classifications/readings, supervisor messages, reports, access denials, and correction notices. Search supports text and filters for frequency, mode, date, station ID, classification, and record status. Sorting and grouping support comparison. Each record shows its current version and accessible earlier versions/correction notices; history is never silently rewritten.

The private notebook supports notes, theories, labels, bookmarks, links between records, and open questions. A separate basic local folder lets players retain selected recordings, transcripts, reports, and documents. No capacity puzzle, encryption puzzle, complex evidence board, or export outside the game.

Reports use structured fields: frequency, mode, signal type/classification, observations, recommended action, Additional Technical Notes, and General Report Notes. Frequency, mode, time, Signal ID, and linked recording auto-populate where possible. Submitted reports are permanent; corrections create new entries.

Choices affect a small number of hidden variables (institutional trust, evidence integrity, disclosure). Consequences should make sense in retrospect. No visible morality score; no early choice may permanently block critical evidence.

## 10. Opening Experience

1. Mara Venn of Regional Operations gives a brief professional welcome.
2. The player arrives at the Receiver with **RX OFF** and powers it on.
3. A consistent startup check runs; the receiver tunes to the regulatory time standard.
4. Contextual onboarding teaches the waterfall, modes, ordinary traffic, recording, and transcript through play—not a separate checklist.
5. Routine interference/identifier work introduces the archive and report form.

## 11. Explicit Scope Exclusions

No 3D, walkable world, character animation, real RF DSP, actual speech recognition, online AI, real SDR input, online services, microphone access, export-to-file, or complex evidence-board UI.

## 12. Implementation Gate

Do not begin coding until the concept/design is sufficiently settled and the user explicitly asks to begin. Godot 4.x and the under-25-MB target require a later minimal prototype/export test before either can be treated as validated.
