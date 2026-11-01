# DEAD AIR — Offline Audio & Speech Engine

**Status:** Prototype implementation v0.1.1

## Purpose
Provide optional local audio for receiver atmosphere and readable speech output without relying on internet access, cloud services, the Android system speech provider, or microphone permissions.

## Current implementation
- Receiver hiss remains generated locally with a faint 73 Hz tone and is gated by receiver power.
- Speech is synthesized on demand from the selected retained event's authored transcript.
- The formant synthesizer is implemented in GDScript and emits mono 16-bit PCM at 22,050 Hz as an AudioStreamWAV.
- Basic grapheme-to-phoneme rules cover English letters, common vowel pairs, consonants, punctuation pauses, digits, and uppercase initialisms.
- Uppercase initialisms and digits are expanded for readout (for example, NR-041 becomes spoken letter names and individual digits).
- The readout is deliberately synthetic and slightly restrained in pitch/speed. It is not represented as an original recording or an actual human performance.
- Playback is initiated by the player using READ DECODE ALOUD on Receiver or Recordings.
- The existing audio preference mutes receiver hiss and speech playback together.

## Canon and accessibility rules
- The transcript is always visible and remains the authoritative evidence.
- Speech is optional. No assignment, clue, classification, or progression gate depends on listening.
- Generated speech must not imply a common transmitter, hidden speaker identity, or a confirmed explanation of NR-041.
- A readout of a CW decode is a spoken accessibility rendering of the text, not a claim that the original CW transmission contained voice.
- No microphone, speech recognition, online TTS, analytics, network permission, or downloaded model is used.

## Package budget
- Base game allowance: 25 MB.
- Additional audio/speech allowance: up to 25 MB.
- Total package ceiling: 50 MB.
- The current procedural engine adds source code rather than a large voice model. Do not add large audio assets merely to consume the allowance. Measure both debug and release APKs after changes.

## Verification
- Headless self-test synthesizes the same sample twice and checks that the output is non-empty, deterministic, mono, 22.05 kHz, and bounded in duration.
- UI flow verifies the readout action is present through the shared receiver/recordings view path and that audio preference persistence remains intact.
- Android export must retain the no-INTERNET/no-RECORD_AUDIO manifest audit.
- Physical-device sound quality, speaker volume, and lifecycle interruption still require device verification.

## Known limitations / next increments
- The current voice is a simple formant synthesizer. It is intentionally more radio-terminal than natural human speech.
- Pronunciation is rule-based and English-focused; uncommon names and specialist vocabulary may be approximated.
- The initial playable content has limited voice material. Future authored traffic can provide explicit speech text, speaker profile, rate, pitch, and radio-channel treatment without changing the canonical transcript.
- Future improvements should add phoneme exceptions and authored voice profiles before considering a larger voice model. Preserve offline operation and the 50 MB total package ceiling.
