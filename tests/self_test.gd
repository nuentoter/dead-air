extends SceneTree

const Catalog = preload("res://scripts/content_catalog.gd")
const GameState = preload("res://scripts/game_state.gd")
const SpeechEngine = preload("res://scripts/speech_engine.gd")
const SignalAudioEngine = preload("res://scripts/signal_audio_engine.gd")

var test_failed := false

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var speech_a: AudioStreamWAV = SpeechEngine.synthesize("Hi.", 1.0, 1.0)
	var speech_b: AudioStreamWAV = SpeechEngine.synthesize("Hi.", 1.0, 1.0)
	_assert(speech_a != null and speech_b != null, "Offline speech synthesis did not return an audio stream.")
	_assert(speech_a.mix_rate == 22050 and not speech_a.stereo, "Speech stream format is not the expected compact mono format.")
	_assert(speech_a.data.size() > 4000 and speech_a.data == speech_b.data, "Speech output should be non-empty and deterministic.")
	_assert(speech_a.data.size() < 22050 * 2 * 30, "Speech synthesis exceeded the bounded test output duration.")
	_assert(String(SpeechEngine._expand_text("NR-041")).contains("zero four one"), "Identifier and digit expansion failed.")
	var field_voice: AudioStreamWAV = SpeechEngine.synthesize("Hi.", 1.0, 1.0, "FIELD")
	var official_voice: AudioStreamWAV = SpeechEngine.synthesize("Hi.", 1.0, 1.0, "OFFICIAL")
	_assert(field_voice.data != official_voice.data, "Authored voice profiles should produce distinct local readouts.")
	var cw_event := _event("SIG-0004").duplicate(true)
	cw_event["identifier"] = "N"
	cw_event["sequence"] = "1"
	var voice_event := _event("SIG-0002").duplicate(true)
	voice_event["transcript"] = "Hi."
	var cw_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(cw_event)
	var weak_cw_event := _event("SIG-0005").duplicate(true)
	weak_cw_event["identifier"] = "N"
	weak_cw_event["sequence"] = "1"
	var weak_cw_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(weak_cw_event)
	var voice_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(voice_event)
	var data_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0003"))
	var carrier_audio: AudioStreamWAV = SignalAudioEngine.build_event_audio(_event("SIG-0001"))
	for signal_audio in [cw_audio, weak_cw_audio, voice_audio, data_audio, carrier_audio]:
		_assert(signal_audio != null and signal_audio.mix_rate == 22050 and not signal_audio.stereo, "Signal renderer returned an invalid stream.")
		_assert(signal_audio.data.size() > 4000, "Signal renderer returned an empty or too-short stream.")
	_assert(cw_audio.data.size() > data_audio.data.size(), "CW identifier/sequence should produce a longer keyed signal than the partial data burst.")
	_assert(cw_audio.data.size() == weak_cw_audio.data.size(), "Weak CW reception should preserve the keyed message timing.")
	_assert(_audio_peak(weak_cw_audio.data) < _audio_peak(cw_audio.data), "The weaker recurring CW reception should be quieter than the first reception.")
	_assert(carrier_audio.data.size() > data_audio.data.size(), "Time-standard ticks should be longer than the partial data burst.")
	_assert(carrier_audio.data.size() > 22050 * 2 * 4, "Top-of-hour reference pattern should include several seconds of time-standard ticks.")
	_assert(data_audio.data.size() < cw_audio.data.size(), "Incomplete data burst should remain a short non-textual event.")
	_assert(Catalog.EVENTS.size() == 5, "Expected five canonical opening signal events.")
	_assert(Catalog.DOCUMENTS.size() >= 6, "Expected core archive documents including the closed incident-file cover.")
	var ids: Array[String] = []
	for event in Catalog.EVENTS:
		ids.append(String(event.get("id", "")))
	_assert(ids.has("SIG-0001") and ids.has("SIG-0005"), "Opening signal IDs must be present.")
	var first := _event("SIG-0004")
	var repeat := _event("SIG-0005")
	_assert(String(first.get("identifier", "")) == "NR-041", "First reception identifier mismatch.")
	_assert(String(repeat.get("identifier", "")) == "NR-041", "Recurring reception identifier mismatch.")
	_assert(String(first.get("sequence", "")) == "731904", "First sequence mismatch.")
	_assert(String(repeat.get("sequence", "")) == "731904", "Recurring sequence mismatch.")
	_assert(float(first.get("frequency_mhz", 0.0)) == 7.418, "First frequency mismatch.")
	_assert(float(repeat.get("frequency_mhz", 0.0)) == 7.418, "Recurring frequency mismatch.")

	var m07 := _document("M-07")
	var m08 := _document("M-08")
	var m09 := _document("M-09")
	_assert(String(m07.get("body", "")).contains("18:00"), "M-07 must preserve 18:00.")
	for stamp in ["18:17", "18:19", "18:23"]:
		_assert(String(m08.get("body", "")).contains(stamp), "M-08 missing " + stamp)
	for stamp in ["18:19", "18:21", "18:23"]:
		_assert(String(m09.get("body", "")).contains(stamp), "M-09 missing " + stamp)

	var state := GameState.new()
	state.data["communications_comparison_reviewed"] = false
	state.data["assignments"]["A-005"] = "OPEN"
	state.save_game()
	for event_id in ids:
		_assert(state.data["retained_event_ids"].has(event_id), "Essential authored event not retained: " + event_id)
	state.set_receiver(true, 10.0, "AM")
	state.select_event("SIG-0001")
	_assert(String(state.data["assignments"]["A-001"]) == "COMPLETED", "A-001 should complete after receiver check and reference event inspection.")
	state.select_event("SIG-0004")
	_assert(String(state.data["assignments"]["A-002"]) == "IN PROGRESS", "A-002 should show progress after inspecting an identifier before registry lookup.")
	_assert(String(state.data["assignments"]["A-003"]) == "IN PROGRESS", "A-003 should show progress after inspecting one recurring reception.")
	state.mark_document_read("M-02")
	_assert(String(state.data["assignments"]["A-002"]) == "COMPLETED", "A-002 should complete after NR-041 inspection and registry lookup.")
	state.mark_document_read("M-06A")
	_assert(String(state.data["assignments"]["A-004"]) == "IN PROGRESS", "A-004 should show progress after opening its first required record.")
	state.mark_document_read("M-07")
	state.mark_document_read("M-08")
	_assert(String(state.data["assignments"]["A-004"]) == "COMPLETED", "A-004 should complete after reviewing the incident-file cover, M-07, and M-08.")
	state.mark_document_read("M-09")
	_assert(String(state.data["assignments"]["A-005"]) == "IN PROGRESS", "A-005 should show progress before explicit comparison review.")
	_assert(String(state.data["assignments"]["A-005"]) != "COMPLETED", "A-005 must require an explicit comparison review.")
	_assert(state.complete_communications_comparison(), "A-005 comparison should complete after both M-08 and M-09 are reviewed.")
	_assert(String(state.data["assignments"]["A-005"]) == "COMPLETED", "A-005 should complete after explicit comparison review.")
	var report_count_before: int = state.data.get("reports", []).size()
	state.data["assignments"]["A-006"] = "IN PROGRESS"
	state.data["report_source_ids"] = ["M-07", "M-08", "M-09"]
	var report: Dictionary = state.submit_report("Test observation: chronology remains unresolved.", "Retain records and request clock/source documentation.", state.data["report_source_ids"])
	_assert(String(report.get("status", "")) == "SUBMITTED", "Report was not submitted.")
	_assert(report.get("source_ids", []) == ["M-07", "M-08", "M-09"], "Submitted report must preserve the selected source links.")
	_assert(String(report.get("case_status", "")) == "UNRESOLVED", "Report must not resolve the case.")
	_assert(String(state.data["assignments"]["A-006"]) == "CLOSED", "A-006 should close after submission.")
	state.data["settings"]["text_scale"] = 1.1
	state.save_game()
	var addendum: Dictionary = state.submit_report("Addendum: source attribution remains unverified.", "Request independent technical review.", ["M-07", "M-08", "M-09"])
	_assert(String(addendum.get("kind", "")) == "ADDENDUM", "Second submission must be labeled addendum.")
	_assert(String(state.data["reports"][report_count_before].get("body", "")) == "Test observation: chronology remains unresolved.", "Submitted report was silently rewritten.")
	_assert(state.data["reports"].size() == report_count_before + 2, "Both report records must remain in history.")
	var reloaded := GameState.new()
	_assert(reloaded.data.get("reports", []).size() >= report_count_before + 2, "Submitted reports did not persist.")
	_assert(String(reloaded.data["reports"][-1].get("case_status", "")) == "UNRESOLVED", "Persisted case status changed.")
	_assert(bool(reloaded.data.get("communications_comparison_reviewed", false)), "Explicit A-005 comparison review did not persist.")
	_assert(is_equal_approx(float(reloaded.data["settings"].get("text_scale", 1.0)), 1.1), "Text size setting did not persist.")
	_assert(is_equal_approx(float(reloaded.data["settings"].get("speech_rate", 1.0)), 1.0), "Speech rate default did not persist.")
	var save_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	_assert(save_file != null, "Could not open valid save before recovery test.")
	var valid_save_text := save_file.get_as_text()
	save_file.close()
	var legacy_data = JSON.parse_string(valid_save_text)
	_assert(typeof(legacy_data) == TYPE_DICTIONARY, "Could not parse save for legacy A-005 migration test.")
	legacy_data.erase("communications_comparison_reviewed")
	legacy_data["assignments"]["A-005"] = "COMPLETED"
	var legacy_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	_assert(legacy_file != null, "Could not open save for legacy A-005 migration test.")
	legacy_file.store_string(JSON.stringify(legacy_data, "\t"))
	legacy_file.close()
	var migrated := GameState.new()
	_assert(not bool(migrated.data.get("communications_comparison_reviewed", false)), "Legacy save should not invent an explicit comparison review.")
	_assert(String(migrated.data["assignments"]["A-005"]) == "IN PROGRESS", "Legacy auto-completed A-005 should migrate to in-progress.")
	_assert(migrated.save_game(), "Could not persist the migrated A-005 state.")
	save_file = FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	_assert(save_file != null, "Could not reopen migrated save.")
	valid_save_text = save_file.get_as_text()
	save_file.close()
	var legacy_settings_data = JSON.parse_string(valid_save_text)
	legacy_settings_data["settings"].erase("speech_rate")
	legacy_settings_data["frequency_mhz"] = 145.5
	legacy_settings_data["mode"] = "INVALID"
	legacy_settings_data.erase("band")
	var legacy_settings_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	_assert(legacy_settings_file != null, "Could not open save for speech-setting migration test.")
	legacy_settings_file.store_string(JSON.stringify(legacy_settings_data, "\\t"))
	legacy_settings_file.close()
	var settings_migrated := GameState.new()
	_assert(is_equal_approx(float(settings_migrated.data["settings"].get("speech_rate", 0.0)), 1.0), "Older save without speech_rate should receive the default speed.")
	_assert(String(settings_migrated.data.get("band", "")) == "VHF", "Older save without band should infer VHF from its 145.5 MHz frequency.")
	_assert(String(settings_migrated.data.get("mode", "")) == "AM", "Unknown legacy mode should migrate to AM safely.")
	_assert(settings_migrated.save_game(), "Could not persist speech-setting migration.")
	save_file = FileAccess.open(GameState.SAVE_PATH, FileAccess.READ)
	_assert(save_file != null, "Could not reopen migrated speech settings.")
	valid_save_text = save_file.get_as_text()
	save_file.close()
	var corrupt_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	_assert(corrupt_file != null, "Could not open save for malformed-save test.")
	corrupt_file.store_string("{ this is deliberately not valid JSON")
	corrupt_file.close()
	var recovered := GameState.new()
	_assert(not String(recovered.load_notice).is_empty(), "Malformed save should produce a recovery notice.")
	_assert(FileAccess.file_exists(GameState.RECOVERY_PATH), "Malformed save should be preserved in the recovery copy.")
	var recovery_file := FileAccess.open(GameState.RECOVERY_PATH, FileAccess.READ)
	_assert(recovery_file != null, "Recovery copy could not be opened.")
	_assert(recovery_file.get_as_text().contains("deliberately not valid JSON"), "Recovery copy did not preserve the original malformed save.")
	recovery_file.close()
	var restore_file := FileAccess.open(GameState.SAVE_PATH, FileAccess.WRITE)
	_assert(restore_file != null, "Could not restore valid save after recovery test.")
	restore_file.store_string(valid_save_text)
	restore_file.close()
	var final_reload := GameState.new()
	_assert(final_reload.data.get("reports", []).size() >= report_count_before + 2, "Valid save could not be restored after malformed-save test.")
	if test_failed:
		push_error("DEAD AIR self-test failed. See assertion messages above.")
		quit(1)
		return
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

func _assert(condition: bool, message: String) -> void:
	if not condition:
		test_failed = true
		push_error(message)

func _audio_peak(pcm: PackedByteArray) -> int:
	var peak := 0
	for offset in range(0, pcm.size(), 2):
		peak = maxi(peak, abs(pcm.decode_s16(offset)))
	return peak
