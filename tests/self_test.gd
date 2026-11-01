extends SceneTree

const Catalog = preload("res://scripts/content_catalog.gd")
const GameState = preload("res://scripts/game_state.gd")
const SpeechEngine = preload("res://scripts/speech_engine.gd")
const SignalAudioEngine = preload("res://scripts/signal_audio_engine.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var speech_a: AudioStreamWAV = SpeechEngine.synthesize("Hi NR-041.", 1.0, 1.0)
	var speech_b: AudioStreamWAV = SpeechEngine.synthesize("Hi NR-041.", 1.0, 1.0)
	assert(speech_a != null and speech_b != null, "Offline speech synthesis did not return an audio stream.")
	assert(speech_a.mix_rate == 22050 and not speech_a.stereo, "Speech stream format is not the expected compact mono format.")
	assert(speech_a.data.size() > 22050 and speech_a.data == speech_b.data, "Speech output should be non-empty and deterministic.")
	assert(speech_a.data.size() < 22050 * 2 * 30, "Speech synthesis exceeded the bounded test output duration.")
	var cw_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0004"))
	var voice_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0002"))
	var data_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0003"))
	var carrier_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0001"))
	for signal_audio in [cw_audio, voice_audio, data_audio, carrier_audio]:
		assert(signal_audio != null and signal_audio.mix_rate == 22050 and not signal_audio.stereo, "Signal renderer returned an invalid stream.")
		assert(signal_audio.data.size() > 4000, "Signal renderer returned an empty or too-short stream.")
	assert(cw_audio.data.size() > carrier_audio.data.size(), "CW identifier/sequence should produce a longer keyed signal than the reference carrier.")
	assert(data_audio.data.size() < cw_audio.data.size(), "Incomplete data burst should remain a short non-textual event.")
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
	state.data["communications_comparison_reviewed"] = false
	state.data["assignments"]["A-005"] = "OPEN"
	state.save_game()
	for event_id in ids:
		assert(state.data["retained_event_ids"].has(event_id), "Essential authored event not retained: " + event_id)
	state.set_receiver(true, 10.0, "AM")
	state.select_event("SIG-0001")
	assert(String(state.data["assignments"]["A-001"]) == "COMPLETED", "A-001 should complete after receiver check and reference event inspection.")
	state.select_event("SIG-0004")
	assert(String(state.data["assignments"]["A-002"]) == "IN PROGRESS", "A-002 should show progress after inspecting an identifier before registry lookup.")
	assert(String(state.data["assignments"]["A-003"]) == "IN PROGRESS", "A-003 should show progress after inspecting one recurring reception.")
	state.mark_document_read("M-02")
	assert(String(state.data["assignments"]["A-002"]) == "COMPLETED", "A-002 should complete after NR-041 inspection and registry lookup.")
	state.mark_document_read("M-06A")
	assert(String(state.data["assignments"]["A-004"]) == "IN PROGRESS", "A-004 should show progress after opening its first required record.")
	state.mark_document_read("M-07")
	state.mark_document_read("M-08")
	assert(String(state.data["assignments"]["A-004"]) == "COMPLETED", "A-004 should complete after reviewing the incident-file cover, M-07, and M-08.")
	state.mark_document_read("M-09")
	assert(String(state.data["assignments"]["A-005"]) == "IN PROGRESS", "A-005 should show progress before explicit comparison review.")
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
	assert(bool(reloaded.data.get("communications_comparison_reviewed", false)), "Explicit A-005 comparison review did not persist.")
	assert(is_equal_approx(float(reloaded.data["settings"].get("text_scale", 1.0)), 1.1), "Text size setting did not persist.")
	assert(is_equal_approx(float(reloaded.data["settings"].get("speech_rate", 1.0)), 1.0), "Speech rate default did not persist.")
	var save_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	assert(save_file != null, "Could not open valid save before recovery test.")
	var valid_save_text := save_file.get_as_text()
	save_file.close()
	var legacy_data = JSON.parse_string(valid_save_text)
	assert(typeof(legacy_data) == TYPE_DICTIONARY, "Could not parse save for legacy A-005 migration test.")
	legacy_data.erase("communications_comparison_reviewed")
	legacy_data["assignments"]["A-005"] = "COMPLETED"
	var legacy_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	assert(legacy_file != null, "Could not open save for legacy A-005 migration test.")
	legacy_file.store_string(JSON.stringify(legacy_data, "\t"))
	legacy_file.close()
	var migrated := GameState.new()
	assert(not bool(migrated.data.get("communications_comparison_reviewed", false)), "Legacy save should not invent an explicit comparison review.")
	assert(String(migrated.data["assignments"]["A-005"]) == "IN PROGRESS", "Legacy auto-completed A-005 should migrate to in-progress.")
	assert(migrated.save_game(), "Could not persist the migrated A-005 state.")
	save_file = FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	assert(save_file != null, "Could not reopen migrated save.")
	valid_save_text = save_file.get_as_text()
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
