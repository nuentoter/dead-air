extends SceneTree

const Catalog = preload("res://scripts/content_catalog.gd")
const GameState = preload("res://scripts/game_state.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	assert(Catalog.EVENTS.size() == 5, "Expected five canonical opening signal events.")
	assert(Catalog.DOCUMENTS.size() >= 6, "Expected core archive documents including the closed incident-file cover.")
	var ids: Array[String] = []
	for event in Catalog.EVENTS:
		ids.append(String(event.get("id", "")))
	assert(ids.has("SIG-0001") and ids.has("SIG-0005"), "Opening signal IDs must be present.")
	var first := _event("SIG-0004")
	var repeat := _event("SIG-0005")
	assert(String(first.get("identifier", "")) == "NR-041", "First reception identifier mismatch.")
	assert(String(repeat.get("identifier", "")) == "NR-041", "Recurring reception identifier mismatch.")
	assert(String(first.get("sequence", "")) == "731904", "First sequence mismatch.")
	assert(String(repeat.get("sequence", "")) == "731904", "Recurring sequence mismatch.")
	assert(float(first.get("frequency_mhz", 0.0)) == 7.418, "First frequency mismatch.")
	assert(float(repeat.get("frequency_mhz", 0.0)) == 7.418, "Recurring frequency mismatch.")

	var m07 := _document("M-07")
	var m08 := _document("M-08")
	var m09 := _document("M-09")
	assert(String(m07.get("body", "")).contains("18:00"), "M-07 must preserve 18:00.")
	for stamp in ["18:17", "18:19", "18:23"]:
		assert(String(m08.get("body", "")).contains(stamp), "M-08 missing " + stamp)
	for stamp in ["18:19", "18:21", "18:23"]:
		assert(String(m09.get("body", "")).contains(stamp), "M-09 missing " + stamp)

	var state := GameState.new()
	for event_id in ids:
		assert(state.data["retained_event_ids"].has(event_id), "Essential authored event not retained: " + event_id)
	state.set_receiver(true, 10.0, "AM")
	state.select_event("SIG-0001")
	assert(String(state.data["assignments"]["A-001"]) == "COMPLETED", "A-001 should complete after receiver check and reference event inspection.")
	state.select_event("SIG-0004")
	state.mark_document_read("M-02")
	assert(String(state.data["assignments"]["A-002"]) == "COMPLETED", "A-002 should complete after NR-041 inspection and registry lookup.")
	state.mark_document_read("M-06A")
	state.mark_document_read("M-07")
	state.mark_document_read("M-08")
	assert(String(state.data["assignments"]["A-004"]) == "COMPLETED", "A-004 should complete after reviewing the incident-file cover, M-07, and M-08.")
	state.mark_document_read("M-09")
	assert(String(state.data["assignments"]["A-005"]) != "COMPLETED", "A-005 must require an explicit comparison review.")
	assert(state.complete_communications_comparison(), "A-005 comparison should complete after both M-08 and M-09 are reviewed.")
	assert(String(state.data["assignments"]["A-005"]) == "COMPLETED", "A-005 should complete after explicit comparison review.")
	var report_count_before: int = state.data.get("reports", []).size()
	state.data["assignments"]["A-006"] = "IN PROGRESS"
	state.data["report_source_ids"] = ["M-07", "M-08", "M-09"]
	var report: Dictionary = state.submit_report("Test observation: chronology remains unresolved.", "Retain records and request clock/source documentation.", state.data["report_source_ids"])
	assert(String(report.get("status", "")) == "SUBMITTED", "Report was not submitted.")
	assert(report.get("source_ids", []) == ["M-07", "M-08", "M-09"], "Submitted report must preserve the selected source links.")
	assert(String(report.get("case_status", "")) == "UNRESOLVED", "Report must not resolve the case.")
	assert(String(state.data["assignments"]["A-006"]) == "CLOSED", "A-006 should close after submission.")
	state.data["settings"]["text_scale"] = 1.1
	state.save_game()
	var addendum: Dictionary = state.submit_report("Addendum: source attribution remains unverified.", "Request independent technical review.", ["M-07", "M-08", "M-09"])
	assert(String(addendum.get("kind", "")) == "ADDENDUM", "Second submission must be labeled addendum.")
	assert(String(state.data["reports"][report_count_before].get("body", "")) == "Test observation: chronology remains unresolved.", "Submitted report was silently rewritten.")
	assert(state.data["reports"].size() == report_count_before + 2, "Both report records must remain in history.")
	var reloaded := GameState.new()
	assert(reloaded.data.get("reports", []).size() >= report_count_before + 2, "Submitted reports did not persist.")
	assert(String(reloaded.data["reports"][-1].get("case_status", "")) == "UNRESOLVED", "Persisted case status changed.")
	assert(is_equal_approx(float(reloaded.data["settings"].get("text_scale", 1.0)), 1.1), "Text size setting did not persist.")
	var save_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	assert(save_file != null, "Could not open valid save before recovery test.")
	var valid_save_text := save_file.get_as_text()
	save_file.close()
	var corrupt_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	assert(corrupt_file != null, "Could not open save for malformed-save test.")
	corrupt_file.store_string("{ this is deliberately not valid JSON")
	corrupt_file.close()
	var recovered := GameState.new()
	assert(not String(recovered.load_notice).is_empty(), "Malformed save should produce a recovery notice.")
	assert(FileAccess.file_exists(GameState.RECOVERY_PATH), "Malformed save should be preserved in the recovery copy.")
	var recovery_file := FileAccess.open(GameState.RECOVERY_PATH, FileAccess.READ)
	assert(recovery_file != null, "Recovery copy could not be opened.")
	assert(recovery_file.get_as_text().contains("deliberately not valid JSON"), "Recovery copy did not preserve the original malformed save.")
	recovery_file.close()
	var restore_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	assert(restore_file != null, "Could not restore valid save after recovery test.")
	restore_file.store_string(valid_save_text)
	restore_file.close()
	var final_reload := GameState.new()
	assert(final_reload.data.get("reports", []).size() >= report_count_before + 2, "Valid save could not be restored after malformed-save test.")
	print("DEAD AIR self-test passed: catalog, chronology, retention, immutable reports, addendum, accessibility, persistence, malformed-save recovery.")
	quit(0)

func _event(event_id: String) -> Dictionary:
	for event in Catalog.EVENTS:
		if String(event.get("id", "")) == event_id:
			return event
	return {}

func _document(document_id: String) -> Dictionary:
	for document in Catalog.DOCUMENTS:
		if String(document.get("id", "")) == document_id:
			return document
	return {}
