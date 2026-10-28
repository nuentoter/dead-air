# DEAD AIR — Opening Shift Playable Script

*Working draft based on the Game Design Document and Master Chronology & Evidence Ledger. This is narrative/UI scripting, not game code. Frequencies and exact timestamps remain placeholders until standardized.*

## Script goals

Teach the receiver through ordinary work; establish Mara Venn as professional and procedural; make the first discrepancy concrete but not supernatural; let the player save evidence and submit a report; end with an administrative closure that fails to resolve the discrepancy.

The receiver must behave consistently. No fake glitches, impossible controls, or essential clues available only through audio.

## Sequence 0 — Shift handover

**Screen:** Handover / Regional Operations  
**State:** New shift. Receiver is off. Archive and notebook are available.

**Mara Venn — message**

> Site 04, good morning. You're assigned routine identifier verification and interference review for this shift.
>
> The receiver configuration is loaded from the previous handover. Confirm the equipment status, then bring RX online and verify the time standard before you begin.
>
> Log anything that meets reporting criteria. If an identifier cannot be confirmed against the registry, record what you received and report the discrepancy. Do not infer a source from the identifier alone.
>
> I'll review anything you submit. Regional Operations may close a task when the available records don't support further action. That status is administrative; keep your original observations in the report.

**Player actions:** Open the handover; acknowledge it; view assignment list.

**Assignments**
- `A-001 — Verify receiver startup and time standard`
- `A-002 — Review an identifier reported during routine monitoring` *(held until A-001 is complete)*

**Design note:** No timer or deadline. The player may inspect the archive/notebook first without penalty.

## Sequence 1 — Receiver startup

**Screen:** Receiver  
**Initial state:** `RX OFF`; no signal is selected.

**Player action:** Press POWER / RX ON.

**System output**

> RECEIVER STARTUP CHECK  
> Receiver state: READY  
> Frequency reference: AVAILABLE  
> Audio path: READY  
> Recording buffer: READY  
> Archive connection: LOCAL  
> RX: ON

The receiver tunes to the regulatory time standard. Use a final frequency only after the frequency plan is standardized.

**Tutorial prompts (contextual, dismissible)**
1. “The waterfall shows signal activity over time. New activity appears at the top; older rows move down.”
2. “Tap a visible signal to tune to it. The selected mode affects how the signal is interpreted.”
3. “Recording preserves the reception you captured. The transcript may contain less detail than the underlying authored transmission.”
4. “The archive stores the record and its current interpretation. Later corrections are linked records; the original is not silently rewritten.”

**Routine time-standard event**

The time standard is clean and ordinary. The player can tune, view signal strength, and optionally record it. Recording this event is not required to proceed.

**Completion condition:** Player has powered on the receiver and opened the time-standard signal panel. No minimum score or perfect tuning requirement.

## Sequence 2 — Routine traffic and calibration

**Receiver behavior:** Present two or three ordinary signals across the available tuning range. Keep content short and technically legible. The player may explore, but the story progression must not depend on finding one exact live event.

**Example ordinary transcript**

> “…weather office has the updated observation sheet. I'll send the copy after the top of the hour. Confirm you can read me.”

**System annotation:** `VOICE / NARROWBAND — provisional classification`

The player can compare the audio, transcript, mode, bandwidth, and signal-strength readout. Do not mark ordinary traffic as suspicious.

**Mara — assignment note**

> One identifier report remains in the queue from the previous monitoring cycle. Please verify the identifier against the registry and attach a recording if reception permits. If the original event is no longer available live, use the retained event record.

This establishes the recovery rule: the player is not punished for missing a transmission.

## Sequence 3 — NR-041 first detection

**Trigger:** The player opens `A-002` or selects the retained identifier event. If they are actively scanning, the event may appear in the waterfall; otherwise it is available through the assignment's event reference.

**Event parameters:** Frequency, timestamp, signal strength, and exact CW timing are placeholders pending the global frequency/time pass. Identifier content is working canon: `NR-041`.

**Receiver panel**

> Signal ID: `SIG-[placeholder]`  
> Mode: CW  
> Classification: IDENTIFIER — provisional  
> Decode: `NR-041`  
> Decode confidence: High  
> Registry match: None returned

**Important distinction:** High decode confidence means the identifier was read reliably. It does not mean the identifier is valid, registered, or correctly attributed.

**Player actions**
- Listen to the CW signal or inspect the decoded text.
- Save a recording.
- Open the registry lookup.
- Compare the receiver's decoded identifier with the registry result.
- Add a note or submit a report.

If the player does not save a recording on first encounter, a recoverable event copy remains available through the assignment. This prevents a single missed click from blocking the story.

## Sequence 4 — Registry response

**Archive artifact:** `M-02 — Registry response`

> **Identifier lookup: NR-041**  
> Result: NO MATCH  
> Registry statement: No station under identifier NR-041 has been recorded in the current registry history.  
> Action: If the received identifier is believed to be accurate, submit a discrepancy report with reception details.

**What this establishes:** The registry says no such station has existed in its records.

**What it does not establish:** That no transmission occurred, that the registry is complete, or that a particular transmitter exists.

The UI does not label this “anomaly,” play a sting, or alter the receiver. It remains a normal discrepancy workflow.

## Sequence 5 — Report composition

**Screen:** Technical report form

Prepopulate where available:
- Signal ID
- Frequency
- Mode
- Reception time
- Linked recording
- Decoded identifier

**Required fields**
- Observation: player selects or writes a concise factual description.
- Recommended action: verify registry entry / request further review.
- Additional Technical Notes: optional.
- General Report Notes: optional.

**Suggested neutral observation text**

> CW identifier decoded as NR-041 with high decoding confidence. Registry lookup returned no matching station record. Reception and registry result conflict. Transmitter identity and origin are not established.

**Player choice — disclosure style**
- **A. Minimal:** “Identifier does not match registry. Request verification.”
- **B. Full record:** “Attach recording and transcript; state that decoding is high-confidence but origin is unverified.”
- **C. Hold for comparison:** Save a private note and continue monitoring before submission.

Choices may affect hidden institutional-trust/disclosure variables, but none can block the recurrence or core evidence. If the player delays submission, the assignment remains open without a deadline.

## Sequence 6 — Mara's first response

After submission and a short simulated work interval, deliver the response.

**Mara Venn — message**

> Received. The identifier does not resolve against the current registry. Your recording supports the decoded text, but it does not establish a transmitter location or an assigned station.
>
> I've logged this as a registry discrepancy and closed the verification request pending new information. Retain the recording and transcript with your shift records. If the identifier recurs under materially different reception conditions, submit a follow-up linked to this report.

**Archive artifact:** `M-03 — Supervisor closure`

**Status:** `CLOSED`

**Player-facing reminder:** Closure applies to the verification request, not to the truth of the signal's origin. The submitted report and recording remain accessible.

## Sequence 7 — End-of-shift bridge / recurrence setup

The player continues ordinary monitoring. Do not force an immediate dramatic event. After the current assignment cycle or next routine shift, make `M-04 — NR-041 recurrence` available.

**Recurrence requirements**
- Same identifier: NR-041.
- Different transmission pattern/timing and weaker or fading reception.
- The receiver and transcript remain internally consistent with the event's signal conditions.
- The recurrence does not prove a shared physical transmitter.
- If missed live, the event remains recoverable in the archive/assignment trail.

**Mara — optional follow-up prompt after recurrence**

> The identifier has appeared again, under different reception conditions. Link the new event to the previous discrepancy if you consider the comparison relevant. Report what differs; avoid assigning a source unless the records support it.

This sets up the next investigation without declaring the first closure foolish or making Mara omniscient.

## Player knowledge at the end of the opening

The player can defensibly conclude:
1. They received a signal that decodes as NR-041.
2. The registry reports no station under that identifier.
3. The player has retained evidence of the reception.
4. Regional Operations closed the initial verification task as a registry discrepancy.
5. The closure did not establish the transmitter's origin or resolve the conflict.

The player must **not** yet know what NR-041 is, where it originates, whether it is connected to the later government-facility incident, or whether the experimental AI had any role.

## Implementation and continuity checklist

- [ ] Exact frequency, timestamps, Signal ID, and CW timing standardized across every artifact.
- [ ] Signal ID is persistent and never changes when classification improves.
- [ ] Recording, transcript, registry result, report, and supervisor response agree on the identifier.
- [ ] Decoding confidence is not confused with source authenticity.
- [ ] Original report and supervisor message remain immutable.
- [ ] Delayed/missed live event has a recovery route.
- [ ] No fake receiver glitches or supernatural UI behavior.
- [ ] No early choice can block M-04 or the main evidence chain.
- [ ] The player is not told that the signal is supernatural, AI-generated, or definitely connected to the research incident.
