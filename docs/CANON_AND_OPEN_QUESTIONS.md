# DEAD AIR — Canon Decisions & Open Questions

This file separates working canon from unresolved design choices. Do not silently turn provisional details into fixed facts.

## Working canon

- Offline, landscape-only Android radio-conspiracy horror; design-first, with no game code until explicitly authorized.
- The player is a technician at Remote Monitoring Site 04, a remote civilian monitoring station.
- The fictional regulator is the National Radio Monitoring Service (NRMS), adopted as working canon v0.2.
- Mara Venn is the Regional Operations supervisor, adopted as working canon v0.2.
- Regional Operations and the Regional Technical Review Office are distinct offices; their exact reporting hierarchy is unspecified.
- The recurring unregistered identifier is NR-041.
- The first major record set uses working IDs 01-773 (closed incident file) and 04-C (interstation communications record).
- Current working sequence is `731904` (meaning unknown); opening time standard is simulated at `10.000 MHz AM`; NR-041 first and recurring receptions use `7.418 MHz CW`.
- Initial Signal IDs are allocated centrally: SIG-0001 time standard, SIG-0002/SIG-0003 routine traffic, SIG-0004 first NR-041 reception, SIG-0005 recurrence. Calendar dates remain placeholders; external clock basis remains unresolved.
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

1. Preserve the adopted working names NRMS, Remote Monitoring Site 04, Mara Venn, Regional Operations, and Regional Technical Review Office unless an explicit rename decision is made.
2. Lock the main chronology only where a specific record requires it; preserve the underlying contradiction.
3. Audit propagation of the working numeric sequence `731904`; its meaning remains unknown.
4. Complete the calendar date timeline and audit all timestamps against the register; preserve the unresolved external clock basis.
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

## Identifier and chronology register

The [Canonical Identifiers & Time Register](CANONICAL_IDENTIFIERS_AND_TIME_REGISTER.md) inventories current names, IDs, timestamps, frequencies, and placeholders. It also records cross-document inconsistencies without silently resolving them. Consult it before adding or revising story records.

## Decision register

The [Prioritized Design Decision Register](PRIORITIZED_DESIGN_DECISION_REGISTER.md) tracks open choices by priority, dependencies, validation method, and implementation-readiness criteria. Use it alongside this file; it does not replace canon or authorize changes to unresolved story facts.
