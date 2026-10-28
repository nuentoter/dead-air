# DEAD AIR — Canon Decisions & Open Questions

This file separates working canon from unresolved design choices. Do not silently turn provisional details into fixed facts.

## Working canon

- Offline, landscape-only Android radio-conspiracy horror; design-first, with no game code until explicitly authorized.
- The player is a technician at Remote Monitoring Site 04, a remote civilian monitoring station.
- The fictional regulator is provisionally named National Radio Monitoring Service (NRMS).
- Mara Venn is the provisional Regional Operations supervisor.
- The recurring unregistered identifier is NR-041.
- The first major record set uses working IDs 01-773 (closed incident file) and 04-C (interstation communications record).
- Official records claim the research facility shut down, while appendices and communications records contain activity afterward. The real chronology remains unresolved.
- The main phenomenon, its intentions, and any causal role for experimental AI must remain unconfirmed.
- Silent Site is an optional, independent records-discrepancy branch. Its package trail ends with ordinary retention handling, while the missing operational logs' fate remains unknown.
- The interface is stable and truthful. Horror comes from evidence, not fake UI failures.
- Essential evidence is recoverable; no real-world waiting, expiring tasks, or penalties for leaving the app.

## Provisional technical/design choices

- Godot 4.x with GDScript is proposed, not validated.
- Package-size target is under 25 MB; actual feasibility requires prototype/export measurement.
- Potential USD $0.99 price is not locked.
- Receiver bands and modes are simplified simulations, not real RF processing.
- All meaningful transmission content is available as text; no real speech recognition or online AI.
- No microphone access, actual SDR input, online services, or export-to-file.

## Decisions to make before final script / implementation

1. Confirm or rename NRMS, Remote Monitoring Site 04, and Mara Venn.
2. Lock the main chronology only where a specific record requires it; preserve the underlying contradiction.
3. Select one canonical numeric sequence and propagate it consistently through every linked record.
4. Standardize frequencies, call signs, record IDs, and all dates/times; label unfixed values as placeholders until then.
5. Decide whether the government facility/research project should remain unnamed.
6. Define final recording and capture behavior: rolling buffer, manual recording, and whether/how auto-archive behaves.
7. Finalize ending branches and their conditions without explaining the central phenomenon.
8. Prototype Godot export size and receiver UI before committing to the under-25-MB target.

## Canon guardrails

- A record's existence does not prove the truth of its contents.
- Do not infer deliberate destruction from a missing inventory item.
- Do not assign illegible initials or invent a package recipient.
- Do not treat matching sequences as proof of a shared transmitter, entity, or AI cause.
- Do not portray Mara as omniscient or definitively villainous.
- Never let a high decoding-confidence value imply that the source or registry entry is true.

## Decision register

The [Prioritized Design Decision Register](PRIORITIZED_DESIGN_DECISION_REGISTER.md) tracks open choices by priority, dependencies, validation method, and implementation-readiness criteria. Use it alongside this file; it does not replace canon or authorize changes to unresolved story facts.
