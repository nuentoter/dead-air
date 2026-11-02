extends RefCounted
class_name DeadAirGameState

const SAVE_PATH = "user://dead_air_save.json"
const TEMP_PATH = "user://dead_air_save.tmp"
const RECOVERY_PATH = "user://dead_air_save.recovery.json"
const SCHEMA_VERSION = 1
const RECORDING_BUFFER_SECONDS = 90
const RECORDING_PRE_ROLL_SECONDS = 30

var data: Dictionary = {}
var load_notice := ""

func _init() -> void:
	if not load_game():
		var had_save := FileAccess.file_exists(SAVE_PATH)
		var recovery_saved := false
		if had_save:
			recovery_saved = DirAccess.copy_absolute(ProjectSettings.globalize_path(SAVE_PATH), ProjectSettings.globalize_path(RECOVERY_PATH)) == OK
		reset_defaults()
		if had_save and recovery_saved:
			load_notice = "Previous save could not be read. A recovery copy was preserved at user://dead_air_save.recovery.json; a clean local state was initialized."
		elif had_save:
			load_notice = "Previous save could not be read and a recovery copy could not be created. A clean local state was initialized."

func reset_defaults() -> void:
	data = {
		"schema_version": SCHEMA_VERSION,
		"current_section": "Receiver",
		"receiver_power": false,
		"frequency_mhz": 10.0,
		"mode": "AM",
		"selected_event_id": "SIG-0001",
		"retained_event_ids": ["SIG-0001", "SIG-0002", "SIG-0003", "SIG-0004", "SIG-0005"],
		"inspected_event_ids": [],
		"recorded_event_ids": [],
		"receiver_controls": {"rf_gain": 55, "af_gain": 55, "squelch": 20, "agc": true, "nb": true},
		"recording_records": [],
		"next_recording_id": 1,
		"ending_disposition": "",
		"ending_history": [],
		"documents_read": [],
		"notes": [],
		"reports": [],
		"communications_comparison_reviewed": false,
		"assignments": {
			"A-001": "OPEN", "A-002": "OPEN", "A-003": "OPEN",
			"A-004": "OPEN", "A-005": "OPEN", "A-006": "OPEN"
		},
		"messages_seen": [],
		"settings": {"text_scale": 1.0, "audio_enabled": true, "speech_rate": 1.0},
		"event_log": [],
		"next_note_id": 1,
		"next_report_id": 1,
		"note_draft": "",
		"note_draft_classification": "UNCLASSIFIED",
		"report_draft": "The retained records establish a repeated identifier and conflicting chronology. The available material does not establish a common transmitter or explain the source-clock difference.",
		"report_recommendation": "Retain records and request clock/source documentation.",
		"report_source_ids": ["SIG-0004", "SIG-0005", "M-02", "M-05", "M-07", "M-08", "M-09"]
	}
	save_game()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	if int(parsed.get("schema_version", 0)) != SCHEMA_VERSION:
		return false
	data = parsed
	_ensure_defaults()
	return true

func _ensure_defaults() -> void:
	var legacy_a005_completed := not bool(data.get("communications_comparison_reviewed", false)) and String(data.get("assignments", {}).get("A-005", "OPEN")) == "COMPLETED"
	var defaults := {
		"current_section": "Receiver", "receiver_power": false, "frequency_mhz": 10.0,
		"mode": "AM", "selected_event_id": "SIG-0001", "retained_event_ids": [],
		"inspected_event_ids": [], "recorded_event_ids": [], "receiver_controls": {"rf_gain": 55, "af_gain": 55, "squelch": 20, "agc": true, "nb": true}, "recording_records": [], "next_recording_id": 1, "ending_disposition": "", "ending_history": [], "documents_read": [], "notes": [], "reports": [],
		"assignments": {}, "messages_seen": [], "settings": {"text_scale": 1.0, "audio_enabled": true, "speech_rate": 1.0},
		"event_log": [], "next_note_id": 1, "next_report_id": 1,
		"note_draft": "", "note_draft_classification": "UNCLASSIFIED", "communications_comparison_reviewed": false, "report_draft": "The retained records establish a repeated identifier and conflicting chronology. The available material does not establish a common transmitter or explain the source-clock difference.",
		"report_recommendation": "Retain records and request clock/source documentation.",
		"report_source_ids": ["SIG-0004", "SIG-0005", "M-02", "M-05", "M-07", "M-08", "M-09"]
	}
	for key in defaults:
		if not data.has(key):
			data[key] = defaults[key]
	var settings: Dictionary = data.get("settings", {})
	for setting_key in ["text_scale", "audio_enabled", "speech_rate"]:
		if not settings.has(setting_key):
			settings[setting_key] = 1.0 if setting_key != "audio_enabled" else true
	settings["speech_rate"] = clampf(float(settings.get("speech_rate", 1.0)), 0.75, 1.25)
	data["settings"] = settings
	if typeof(data.get("inspected_event_ids", [])) != TYPE_ARRAY:
		data["inspected_event_ids"] = []
	data["schema_version"] = SCHEMA_VERSION
	if legacy_a005_completed:
		data["assignments"]["A-005"] = "IN PROGRESS" if data["documents_read"].has("M-08") or data["documents_read"].has("M-09") else "OPEN"
	refresh_assignment_progress()
	if data["retained_event_ids"].is_empty():
		data["retained_event_ids"] = ["SIG-0001", "SIG-0002", "SIG-0003", "SIG-0004", "SIG-0005"]
	for key in ["A-001", "A-002", "A-003", "A-004", "A-005", "A-006"]:
		if not data["assignments"].has(key):
			data["assignments"][key] = "OPEN"

func save_game() -> bool:
	var file := FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	var save_abs := ProjectSettings.globalize_path(SAVE_PATH)
	var temp_abs := ProjectSettings.globalize_path(TEMP_PATH)
	var backup_abs := ProjectSettings.globalize_path("user://dead_air_save.bak")
	var had_previous := FileAccess.file_exists(SAVE_PATH)
	if FileAccess.file_exists(backup_abs):
		DirAccess.remove_absolute(backup_abs)
	if had_previous:
		var backup_err := DirAccess.rename_absolute(save_abs, backup_abs)
		if backup_err != OK:
			return false
	var err := DirAccess.rename_absolute(temp_abs, save_abs)
	if err != OK:
		if had_previous:
			DirAccess.rename_absolute(backup_abs, save_abs)
		return false
	if had_previous and FileAccess.file_exists(backup_abs):
		DirAccess.remove_absolute(backup_abs)
	return true

func log_event(message: String) -> void:
	data["event_log"].append({"text": message, "sequence": data["event_log"].size() + 1})
	save_game()

func set_receiver(powered: bool, frequency_mhz: float, mode: String) -> void:
	data["receiver_power"] = powered
	data["frequency_mhz"] = clampf(frequency_mhz, 0.1, 30000.0)
	data["mode"] = mode
	refresh_assignment_progress()
	save_game()

func select_event(event_id: String) -> void:
	data["selected_event_id"] = event_id
	if not data["retained_event_ids"].has(event_id):
		data["retained_event_ids"].append(event_id)
	if not data["inspected_event_ids"].has(event_id):
		data["inspected_event_ids"].append(event_id)
	refresh_assignment_progress()
	save_game()

func mark_document_read(document_id: String) -> void:
	if not data["documents_read"].has(document_id):
		data["documents_read"].append(document_id)
	refresh_assignment_progress()
	save_game()

func refresh_assignment_progress() -> void:
	var inspected: Array = data.get("inspected_event_ids", [])
	var documents: Array = data.get("documents_read", [])
	var assignments: Dictionary = data.get("assignments", {})
	var receiver_ready := bool(data.get("receiver_power", false)) and inspected.has("SIG-0001")
	_set_assignment_progress(assignments, "A-001", bool(data.get("receiver_power", false)) or inspected.has("SIG-0001"), receiver_ready)
	var identifier_reviewed := inspected.has("SIG-0004") or inspected.has("SIG-0005")
	_set_assignment_progress(assignments, "A-002", identifier_reviewed or documents.has("M-02"), identifier_reviewed and documents.has("M-02"))
	_set_assignment_progress(assignments, "A-003", inspected.has("SIG-0004") or inspected.has("SIG-0005"), false)
	var incident_docs_complete := documents.has("M-06A") and documents.has("M-07") and documents.has("M-08")
	var incident_docs_started := documents.has("M-06A") or documents.has("M-07") or documents.has("M-08")
	_set_assignment_progress(assignments, "A-004", incident_docs_started, incident_docs_complete)
	var communications_started := documents.has("M-08") or documents.has("M-09")
	var communications_complete := bool(data.get("communications_comparison_reviewed", false)) and documents.has("M-08") and documents.has("M-09")
	_set_assignment_progress(assignments, "A-005", communications_started, communications_complete)
	var report_docs_started := documents.has("M-02") or documents.has("M-05") or documents.has("M-07") or documents.has("M-08") or documents.has("M-09")
	_set_assignment_progress(assignments, "A-006", report_docs_started, false)
	data["assignments"] = assignments

func _set_assignment_progress(assignments: Dictionary, assignment_id: String, started: bool, completed: bool) -> void:
	var current := String(assignments.get(assignment_id, "OPEN"))
	if current == "CLOSED" or current == "COMPLETED":
		return
	if completed:
		assignments[assignment_id] = "COMPLETED"
	elif started:
		assignments[assignment_id] = "IN PROGRESS"
	else:
		assignments[assignment_id] = "OPEN"

func complete_communications_comparison() -> bool:
	var documents: Array = data.get("documents_read", [])
	if not documents.has("M-08") or not documents.has("M-09"):
		return false
	data["communications_comparison_reviewed"] = true
	data["assignments"]["A-005"] = "COMPLETED"
	save_game()
	return true

func record_event(event_id: String) -> void:
	# No claim of live captured PCM: this prototype saves a manual excerpt annotation
	# of an already retained authored event. Its institutional source remains intact.
	if not data["retained_event_ids"].has(event_id):
		return
	if data["recorded_event_ids"].has(event_id):
		return
	data["recorded_event_ids"].append(event_id)
	var record_id := "REC-%04d" % int(data["next_recording_id"])
	data["next_recording_id"] = int(data["next_recording_id"]) + 1
	data["recording_records"].append({
		"id": record_id, "event_id": event_id,
		"source_type": "PLAYER EXCERPT ANNOTATION",
		"original_source_type": "INSTITUTIONAL RETAINED EVENT",
		"audio_capture_status": "NOT RECORDED AS PCM",
		"pre_roll_seconds": 0,
		"recording_policy": "90s active-channel buffer / optional 30s pre-roll (future live capture)",
		"provenance_note": "Manual selection of retained authored event; not an independently captured transmission."
	})
	log_event("Manual excerpt annotation " + record_id + " filed for " + event_id + ". Original institutional record unchanged.")
	save_game()


func add_pcm_capture(pcm: PackedByteArray, sample_rate: int, frequency_mhz: float, mode: String, pre_roll_samples: int, status: String) -> Dictionary:
	# This records locally generated receiver-monitor audio only.
	if pcm.is_empty() or sample_rate <= 0:
		return {}
	var rec_id := "REC-%04d" % int(data.get("next_recording_id", 1))
	var relative_path := "user://captures/" + rec_id + ".pcm"
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("user://captures")) != OK:
		return {}
	var file := FileAccess.open(relative_path, FileAccess.WRITE)
	if file == null:
		return {}
	file.store_buffer(pcm)
	file.close()
	var record := {
		"id": rec_id, "source_type": "PLAYER SYNTHETIC MONITOR AUDIO",
		"original_source_type": "LOCAL PROCEDURAL RECEIVER", "audio_capture_status": status,
		"audio_path": relative_path, "sample_rate": sample_rate,
		"sample_count": int(pcm.size() / 2),
		"duration_seconds": float(pcm.size()) / float(sample_rate * 2),
		"pre_roll_seconds": float(pre_roll_samples) / float(sample_rate),
		"frequency_mhz": frequency_mhz, "mode": mode,
		"event_id": "",
		"provenance_note": "Recorded from local synthetic receiver monitor output. Does not capture institutional authored audio, an RF signal, or microphone input."
	}
	data["recording_records"].append(record)
	data["next_recording_id"] = int(data.get("next_recording_id", 1)) + 1
	log_event("Synthetic receiver monitor recording " + rec_id + " filed (" + status + ").")
	save_game()
	return record


func choose_ending(disposition: String) -> bool:
	if not ["CLOSURE", "PRESERVATION", "DISCLOSURE"].has(disposition):
		return false
	if data.get("reports", []).is_empty():
		return false
	if not String(data.get("ending_disposition", "")).is_empty():
		return false
	var record := {
		"id": "END-0001", "disposition": disposition,
		"case_status": "UNRESOLVED",
		"report_id": String(data["reports"][0].get("id", "")),
		"evidence_ids": ["M-02", "M-05", "M-07", "M-08", "M-09"],
		"note": "An administrative decision; does not prove source, clock basis, or cause."
	}
	data["ending_disposition"] = disposition
	data["ending_history"].append(record)
	log_event("Final administrative disposition filed: " + disposition + ". Source remains unresolved.")
	save_game()
	return true

func ending_epilogue() -> String:
	match String(data.get("ending_disposition", "")):
		"CLOSURE":
			return "The work order is closed. The originals remain in the archive. The discrepancy has not been reconciled."
		"PRESERVATION":
			return "Copies and provenance are retained for review. No source attribution or common clock basis is verified."
		"DISCLOSURE":
			return "An independent-review request is logged for transmission outside routine channels. Receipt and interpretation are not confirmed."
	return ""

func add_note(text_value: String, source_id: String = "", classification: String = "UNCLASSIFIED") -> void:
	var trimmed := text_value.strip_edges()
	if trimmed.is_empty():
		return
	var note_id := "NOTE-%04d" % int(data["next_note_id"])
	data["next_note_id"] = int(data["next_note_id"]) + 1
	data["notes"].append({"id": note_id, "text": trimmed, "source_id": source_id, "classification": classification, "created_order": data["notes"].size() + 1})
	log_event("Notebook entry added: " + note_id)
	save_game()

func submit_report(body: String, recommendation: String, source_ids: Array) -> Dictionary:
	if body.strip_edges().is_empty():
		return {}
	var is_addendum: bool = not data.get("reports", []).is_empty()
	var report_id := "REPORT-%04d" % int(data["next_report_id"])
	data["next_report_id"] = int(data["next_report_id"]) + 1
	var report := {
		"id": report_id, "body": body.strip_edges(), "recommendation": recommendation,
		"source_ids": source_ids.duplicate(), "status": "SUBMITTED", "version": 1,
		"kind": "ADDENDUM" if is_addendum else "INITIAL",
		"case_status": "UNRESOLVED"
	}
	data["reports"].append(report)
	data["assignments"]["A-006"] = "CLOSED"
	log_event("Report " + report_id + " submitted. Assignment closed; case remains unresolved.")
	save_game()
	return report

func mark_message_seen(message_id: String) -> void:
	if not data["messages_seen"].has(message_id):
		data["messages_seen"].append(message_id)
	save_game()
