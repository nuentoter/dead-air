extends RefCounted
class_name DeadAirCatalog

const EVENTS = [
	{
		"id": "SIG-0001", "kind": "TIME STANDARD", "frequency_mhz": 10.000, "mode": "AM",
		"time_label": "08:00", "time_basis": "Site 04 simulated local time",
		"identifier": "", "sequence": "", "strength": 0.82, "classification": "REFERENCE",
		"transcript": "Routine reference carrier. Timing stable. No anomalous content.",
		"provenance": "Authored routine event; automatically retained.", "essential": false
	},
	{
		"id": "SIG-0002", "kind": "ROUTINE TRAFFIC", "frequency_mhz": 7.200, "mode": "AM",
		"time_label": "08:12", "time_basis": "Site 04 simulated local time",
		"identifier": "", "sequence": "", "strength": 0.64, "classification": "VOICE / ROUTINE",
		"transcript": "North relay, routine check complete. Weather at the ridge remains overcast. Nothing further.",
		"provenance": "Authored routine event; automatically retained.", "essential": false
	},
	{
		"id": "SIG-0003", "kind": "ROUTINE TRAFFIC", "frequency_mhz": 14.070, "mode": "USB",
		"time_label": "08:26", "time_basis": "Site 04 simulated local time",
		"identifier": "", "sequence": "", "strength": 0.57, "classification": "DATA / PARTIAL",
		"transcript": "Routine station identification and a short data burst. No complete message recovered.",
		"provenance": "Authored routine event; automatically retained.", "essential": false
	},
	{
		"id": "SIG-0004", "kind": "UNREGISTERED IDENTIFIER", "frequency_mhz": 7.418, "mode": "CW",
		"time_label": "17:42", "time_basis": "Prior monitoring cycle; Site 04 simulated local time; date unknown",
		"identifier": "NR-041", "sequence": "731904", "strength": 0.71, "classification": "CW / IDENTIFIER READ",
		"transcript": "Decoded identifier: NR-041. Repeated numeric sequence: 731904. Identifier confidence: high. Sequence confidence: moderate.",
		"provenance": "Retained from prior monitoring cycle; not necessarily heard live by the player.", "essential": true
	},
	{
		"id": "SIG-0005", "kind": "UNREGISTERED IDENTIFIER", "frequency_mhz": 7.418, "mode": "CW",
		"time_label": "08:42", "time_basis": "Next routine shift; Site 04 simulated local time; date unknown",
		"identifier": "NR-041", "sequence": "731904", "strength": 0.39, "classification": "CW / WEAK RECEPTION",
		"transcript": "Decoded identifier: NR-041. Numeric sequence appears to be 731904; sequence confidence lower than identifier confidence. Source not established.",
		"provenance": "Authored recurrence; automatically retained. Matching identifier/frequency does not establish a common transmitter.", "essential": true
	}
]

const DOCUMENTS = [
	{
		"id": "M-02", "title": "Registry Lookup Response", "source": "NRMS Registry Index",
		"claimed_event_time": "Created during current assignment", "clock_basis": "Site 04 simulated local time",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["SIG-0004", "SIG-0005"],
		"body": """NATIONAL RADIO MONITORING SERVICE
REGISTRY LOOKUP RESPONSE

Query: NR-041
Index searched: Registered monitoring stations and assigned identifiers
Result: No matching station record found in this index.

Scope note: This result describes the index searched. It does not establish that no other record or source exists."""
	},
	{
		"id": "M-05", "title": "Site 04 Decoding Worksheet", "source": "Remote Monitoring Site 04",
		"claimed_event_time": "Prior monitoring cycle; date unknown", "clock_basis": "Site 04 simulated local time",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["SIG-0004", "SIG-0005"],
		"body": """SITE 04 — DECODING WORKSHEET

Identifier: NR-041
Repeated numeric sequence: 731904
Identifier confidence: HIGH
Sequence confidence: MODERATE

Notes: Identifier read is more reliable than the numeric sequence. The worksheet does not establish a transmitting station, source, or relationship to another record."""
	},
	{
		"id": "M-06A", "title": "Closed Incident File 01-773 — Cover Sheet", "source": "Regional Technical Review Office",
		"claimed_event_time": "Administrative file status; incident dates not reproduced on this cover", "clock_basis": "Not applicable to this index cover",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["M-07", "M-08", "M-09"],
		"body": """REGIONAL TECHNICAL REVIEW OFFICE
CLOSED INCIDENT FILE — COVER SHEET

File reference: 01-773
Administrative status: CLOSED
Index status: COMPLETE

This cover records the file's administrative status only. It does not certify that every referenced attachment is present, that the source records share a clock basis, or that the underlying chronology has been reconciled."""
	},
	{
		"id": "M-07", "title": "Operations Discontinuation Summary", "source": "Regional Technical Review Office",
		"claimed_event_time": "Operations discontinued at 18:00", "clock_basis": "Source clock basis not stated",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["M-08", "M-09"],
		"body": """FILE: 01-773-SUM
SUBJECT: Operations Discontinuation Summary

The operation was recorded as discontinued at 18:00. Equipment was reported secured following discontinuation.

This summary does not specify the clock source used for the stated time."""
	},
	{
		"id": "M-08", "title": "Technical Appendix: Communications Activity", "source": "Regional Technical Review Office",
		"claimed_event_time": "Entries at 18:17, 18:19, 18:23", "clock_basis": "Origin and clock basis incomplete",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["M-07", "M-09", "01-773"],
		"body": """FILE: 01-773-APP-C
SUBJECT: Technical Appendix — Communications Activity

Recorded entries:
18:17 — Activity entry retained.
18:19 — Routing activity recorded.
18:23 — Further activity recorded.

Origin field: incomplete.
Clock basis: not established by this appendix.

The entries appear later than the 18:00 discontinuation time stated in the summary. This appendix does not reconcile that difference."""
	},
	{
		"id": "M-09", "title": "Communications Record 04-C", "source": "Regional Operations archive search",
		"claimed_event_time": "Entries at 18:19, 18:21, 18:23", "clock_basis": "Source clock not stated",
		"status": "AVAILABLE", "version": 1, "essential": true, "related_ids": ["M-07", "M-08", "01-773"],
		"body": """RECORD: 04-C
SUBJECT: Interstation Communications Log

18:19 — Internal relay receipt recorded.
18:21 — Route-continuation entry.
18:23 — Destination acknowledgement recorded.

Origin identifier: not supplied.
Clock source: not stated.
Receipt confirms that a package or record was indexed here; it does not establish that this copy is an independent original."""
	},
	{
		"id": "M-10B", "title": "Regional Operations Review Response", "source": "Mara Venn, Regional Operations",
		"claimed_event_time": "After report submission", "clock_basis": "Site 04 simulated local time",
		"status": "LOCKED UNTIL REPORT", "version": 1, "essential": true, "related_ids": ["M-07", "M-08", "M-09"],
		"body": """REGIONAL OPERATIONS — REVIEW RESPONSE

Received. No verified registered-station link is established by the material available to this office. The chronology question remains open pending source-clock documentation.

The report is accepted for filing; this acceptance does not confirm the underlying event."""
	},
	{
		"id": "SS-01", "title": "Silent Site — Closure Notice", "source": "Records Index",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-02"],
		"body": """SILENT SITE — CLOSURE NOTICE

Closure completed; transfer described as complete. The notice does not itemize final operational logs.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-02", "title": "Silent Site — Equipment Receipt", "source": "Regional Equipment Desk",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-03"],
		"body": """SILENT SITE — EQUIPMENT RECEIPT

Equipment transfer marked received. Inventory lists equipment and administrative materials; the final monitoring logs are not listed.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-03", "title": "Silent Site — Partial Operations Index", "source": "Site Records Registry",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-04"],
		"body": """SILENT SITE — PARTIAL OPERATIONS INDEX

Operational log index incomplete. Final shift entries are absent from the supplied index. No exception report is attached.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-04", "title": "Silent Site — Neighboring Station Excerpt", "source": "Neighboring Monitoring Station",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-05"],
		"body": """SILENT SITE — NEIGHBORING STATION EXCERPT

Incomplete received audio transcript: '...going back to the site...' No dependable attribution, subject, or full context retained.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-05", "title": "Silent Site — Transfer Dispatch", "source": "Site Transfer Office",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-06"],
		"body": """SILENT SITE — TRANSFER DISPATCH

Package dispatch logged to Regional Operations. The copy lacks an itemized inventory and verified receiving signature.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-06", "title": "Silent Site — Regional Receipt Index", "source": "Regional Operations",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-07"],
		"body": """SILENT SITE — REGIONAL RECEIPT INDEX

Receipt index lists a package with partially legible initials. Contents not verified by the index. Receipt is not an itemized chain of custody.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-07", "title": "Silent Site — Continuity Unit Stamp", "source": "Former Records Continuity Unit",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-08"],
		"body": """SILENT SITE — CONTINUITY UNIT STAMP

Obsolete Records Continuity Unit marking appears in an attached administrative copy. The stamp does not establish who handled the missing logs or when.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	},
	{
		"id": "SS-08", "title": "Silent Site — Final Disposition Notice", "source": "Records Retention Office",
		"claimed_event_time": "Not verified", "clock_basis": "Not established",
		"status": "OPTIONAL", "version": 1, "essential": false, "related_ids": ["SS-01"],
		"body": """SILENT SITE — FINAL DISPOSITION NOTICE

Standard retention policy cited. Package unavailable for retrieval; no itemized disposal record supplied. Disposition remains an administrative finding; fate of final logs unknown.

Evidence limit: This record does not establish deliberate destruction, the location of missing logs, or a connection to NR-041."""
	}
]

const ASSIGNMENTS = [
	{"id": "A-001", "title": "Receiver handover", "description": "Power on the receiver and inspect the routine reference signal.", "status": "OPEN"},
	{"id": "A-002", "title": "Routine identifier check", "description": "Inspect the retained NR-041 event and look up the identifier in the registry.", "status": "OPEN"},
	{"id": "A-003", "title": "Compare recurring identifier", "description": "Compare the two retained NR-041 receptions. Record what matches and what remains uncertain.", "status": "OPEN"},
	{"id": "A-004", "title": "Locate incident-file reference", "description": "Read the operations summary and technical appendix. Note the chronology without choosing which record is wrong.", "status": "OPEN"},
	{"id": "A-005", "title": "Find Communications Record 04-C", "description": "Read M-09 and compare its times and routing details with M-08.", "status": "OPEN"},
	{"id": "A-006", "title": "Submit chronology review", "description": "Report observations, sources, unresolved questions, and a recommended administrative action.", "status": "OPEN"}
]

const MESSAGES = [
	{"id": "MSG-001", "sender": "Mara Venn", "subject": "Shift handover", "body": "Morning. Start with the routine reference check, then review the retained identifier event. If the registry returns no match, report the result as an index finding—not as proof that a source cannot exist.", "unread": true},
	{"id": "MSG-002", "sender": "Site 04 system", "subject": "Retention policy", "body": "Authored events in this training scenario are automatically retained. Manual recording adds a separate provenance entry. Tuning away or changing mode does not delete a retained event.", "unread": true}
]
