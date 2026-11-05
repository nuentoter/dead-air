extends SceneTree
## Protect authored evidence metadata and ambiguous chronology during UI development.
const Catalog = preload("res://scripts/content_catalog.gd")

func _initialize() -> void:
	call_deferred("_run")

func _fail(message: String) -> void:
	push_error(message)
	quit(1)

func _run() -> void:
	var signal_ids := {}
	for event in Catalog.EVENTS:
		var id := String(event.get("id", ""))
		if id.is_empty() or signal_ids.has(id):
			_fail("Empty or duplicate retained signal ID: " + id)
			return
		signal_ids[id] = event
		for key in ["frequency_mhz", "mode", "time_label", "time_basis", "transcript", "provenance"]:
			if not event.has(key) or str(event[key]).strip_edges().is_empty():
				_fail("Signal metadata missing " + key + " in " + id)
				return
		if float(event.get("frequency_mhz", 0.0)) <= 0.0:
			_fail("Invalid retained frequency: " + id)
			return
	var document_ids := {}
	for record in Catalog.DOCUMENTS:
		var id := String(record.get("id", ""))
		if id.is_empty() or document_ids.has(id):
			_fail("Empty or duplicate document ID: " + id)
			return
		document_ids[id] = record
		for key in ["title", "source", "claimed_event_time", "clock_basis", "body"]:
			if String(record.get(key, "")).strip_edges().is_empty():
				_fail("Missing document attribution: " + id + " / " + key)
				return
	for required_signal in ["SIG-0001", "SIG-0002", "SIG-0003", "SIG-0004", "SIG-0005"]:
		if not signal_ids.has(required_signal):
			_fail("Required retained signal missing: " + required_signal)
			return
	for required_doc in ["M-02", "M-05", "M-06A", "M-07", "M-08", "M-09", "M-10B"]:
		if not document_ids.has(required_doc):
			_fail("Required investigation document missing: " + required_doc)
			return
	if String(signal_ids["SIG-0004"].get("time_basis", "")) == String(signal_ids["SIG-0005"].get("time_basis", "")):
		_fail("Different monitoring-cycle clock bases were merged")
		return
	if String(signal_ids["SIG-0004"].get("identifier", "")) != "NR-041" or String(signal_ids["SIG-0005"].get("identifier", "")) != "NR-041":
		_fail("The two retained NR-041 identifiers changed")
		return
	if not String(document_ids["M-07"].get("body", "")).contains("18:00"):
		_fail("M-07 no longer retains its discontinuation time")
		return
	if not String(document_ids["M-08"].get("body", "")).contains("18:23") or not String(document_ids["M-09"].get("body", "")).contains("18:21"):
		_fail("The unresolved communications chronology was modified")
		return
	print("PASS: retained evidence IDs, provenance, and unresolved chronology")
	quit(0)
