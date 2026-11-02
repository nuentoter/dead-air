extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed = ResourceLoader.load("res://scenes/main.tscn", "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
	if packed == null:
		push_error("Cannot load main scene for UI flow test.")
		quit(1)
		return
	var instance = packed.instantiate()
	root.add_child(instance)
	await process_frame
	instance.call("_on_nav_pressed", "Assignments")
	instance.call("_select_assignment", "A-006")
	await process_frame
	var game = instance.get("game")
	var initial_report_count: int = game.data.get("reports", []).size()
	if not _expect(_tree_contains_text(instance, "OPEN  /  M-02 opened"), "A-006 progress checklist should show unopened evidence before review."):
		return
	instance.call("_submit_report")
	assert(game.data.get("reports", []).size() == initial_report_count, "A-006 should block submission until required records are reviewed.")
	instance.call("_on_nav_pressed", "Receiver")
	instance.call("_select_event", "SIG-0004")
	instance.call("_select_event", "SIG-0005")
	instance.call("_on_nav_pressed", "Assignments")
	instance.call("_select_assignment", "A-003")
	instance.call("_complete_comparison_assignment")
	if not _expect(String(game.data["assignments"]["A-003"]) == "COMPLETED", "A-003 comparison did not complete after both events were inspected."):
		return
	instance.call("_on_nav_pressed", "Archive")
	for document_id in ["M-02", "M-05", "M-06A", "M-07", "M-08", "M-09"]:
		instance.call("_select_document", document_id)
	instance.call("_on_nav_pressed", "Assignments")
	instance.call("_select_assignment", "A-005")
	if not _expect(_tree_contains_text(instance, "Shared printed times: 18:19 and 18:23"), "A-005 did not show the side-by-side timestamp comparison."):
		return
	if not _expect(_tree_contains_text(instance, "do not establish an independent original"), "A-005 comparison omitted the source-attribution limit."):
		return
	instance.call("_complete_communications_comparison")
	if not _expect(String(game.data["assignments"]["A-005"]) == "COMPLETED", "A-005 should complete only after explicit comparison review."):
		return
	instance.call("_select_assignment", "A-006")
	await process_frame
	if not _expect(_tree_contains_text(instance, "DONE  /  M-02 opened"), "A-006 checklist did not reflect reviewed evidence."):
		return
	instance.call("_on_report_source_toggled", false, "SIG-0004")
	instance.call("_on_report_source_toggled", false, "SIG-0005")
	instance.call("_on_report_source_toggled", false, "M-02")
	instance.call("_on_report_source_toggled", false, "M-05")
	instance.call("_on_report_source_toggled", false, "M-06A")
	var editor = instance.get("report_editor") as TextEdit
	if editor == null:
		push_error("A-006 report editor was not constructed.")
		quit(1)
		return
	editor.text = "UI test: M-07 and M-08 timestamps conflict; source-clock basis remains unknown."
	instance.call("_on_report_draft_changed")
	instance.call("_submit_report")
	await process_frame
	var reports: Array = game.data.get("reports", [])
	if not _expect(not reports.is_empty(), "UI submission did not create a report."):
		return
	if not _expect(String(reports[-1].get("body", "")).begins_with("UI test:"), "UI submission body was not preserved."):
		return
	if not _expect(String(game.data["assignments"]["A-006"]) == "CLOSED", "UI submission did not close A-006."):
		return
	if not _expect(String(game.data["current_section"]) == "Messages", "UI submission should open Messages."):
		return
	if not _expect(String(reports[-1].get("case_status", "")) == "UNRESOLVED", "UI submission must leave the case unresolved."):
		return
	if not _expect(reports[-1].get("source_ids", []).has("M-07"), "Selected report source M-07 was not attached."):
		return
	if not _expect(not reports[-1].get("source_ids", []).has("SIG-0004"), "Deselected report source SIG-0004 was still attached."):
		return
	if not _expect(_tree_contains_text(instance, String(reports[-1].get("id", ""))), "Submitted report history is not visible in Messages."):
		return
	if not _expect(_tree_contains_text(instance, "Cited source IDs: M-07, M-08, M-09"), "Read-only report history does not display its citations."):
		return
	if not _expect(_tree_contains_text(instance, "FINAL ADMINISTRATIVE DISPOSITION"), "Disposition choices are missing after report submission."):
		return
	instance.call("_choose_ending", "DISCLOSURE")
	if not _expect(String(game.data.get("ending_disposition", "")) == "DISCLOSURE", "Disclosure choice not filed."):
		return
	if not _expect(_tree_contains_text(instance, "independent-review request"), "Disclosure epilogue not visible."):
		return
	instance.call("_open_report_source", "M-07")
	if not _expect(String(game.data["current_section"]) == "Archive", "Opening a report citation did not navigate to Archive."):
		return
	if not _expect(String(instance.get("selected_document_id")) == "M-07", "Opening a report citation did not select the cited document."):
		return
	if not _expect(game.data.get("documents_read", []).has("M-07"), "Opening a report citation did not mark the document as reviewed."):
		return
	instance.call("_select_document", "M-06A")
	if not _expect(_tree_contains_text(instance, "OPEN M-07"), "Incident cover did not expose its indexed related record as a navigation action."):
		return
	instance.call("_open_related_record", "M-07")
	if not _expect(String(instance.get("selected_document_id")) == "M-07", "Opening an archive relationship did not select the linked record."):
		return
	instance.call("_on_nav_pressed", "Notebook")
	await process_frame
	var note_editor = instance.get("note_editor") as TextEdit
	var note_source_select = instance.get("note_source_select") as OptionButton
	var note_class_select = instance.get("note_class_select") as OptionButton
	if not _expect(note_editor != null and note_source_select != null and note_class_select != null, "Notebook note editor, source selector, or classification selector was not built."):
		return
	note_editor.text = "Notebook interpretation: repeated sequence may indicate a shared source; this is not confirmed."
	note_source_select.select(6)
	note_class_select.select(2)
	instance.call("_on_note_classification_selected", 2)
	instance.call("_on_note_draft_changed")
	instance.call("_save_note_from_ui")
	await process_frame
	if not _expect(_tree_contains_text(instance, "Evidence reference: " + String(instance.call("_source_display_title", "M-07"))), "Notebook did not show a readable title for the linked source."):
		return
	if not _expect(_tree_contains_text(instance, "OPEN SOURCE M-07"), "Notebook did not offer a direct action to open its linked source."):
		return
	instance.call("_open_note_source", "M-07")
	if not _expect(String(game.data["current_section"]) == "Archive", "Opening a notebook source did not navigate to Archive."):
		return
	if not _expect(String(instance.get("selected_document_id")) == "M-07", "Opening a notebook source did not select its linked document."):
		return
	if not _expect(String(game.data["notes"][-1].get("text", "")).contains("not confirmed"), "Opening a source altered the notebook interpretation."):
		return
	if not _expect(String(game.data["notes"][-1].get("classification", "")) == "WORKING HYPOTHESIS", "Notebook classification was not persisted with the note."):
		return
	instance.call("_on_nav_pressed", "Notebook")
	if not _expect(_tree_contains_text(instance, "WORKING HYPOTHESIS"), "Saved note did not display its selected classification when revisiting the Notebook."):
		return
	var audio_before: bool = bool(game.data.get("settings", {}).get("audio_enabled", true))
	if not _expect(audio_before, "Receiver audio should default to enabled for the current prototype."):
		return
	instance.call("_toggle_audio")
	if not _expect(not bool(game.data["settings"].get("audio_enabled", true)), "Audio toggle did not persist the muted state."):
		return
	var audio_reload = load("res://scripts/game_state.gd").new()
	if not _expect(not bool(audio_reload.data["settings"].get("audio_enabled", true)), "Muted audio preference did not survive save reload."):
		return
	instance.call("_toggle_audio")
	if not _expect(bool(game.data["settings"].get("audio_enabled", false)), "Audio toggle did not restore enabled state."):
		return
	instance.call("_change_speech_rate", 0.1)
	if not _expect(is_equal_approx(float(game.data["settings"].get("speech_rate", 1.0)), 1.1), "Speech speed control did not update its setting."):
		return
	var speech_reload = load("res://scripts/game_state.gd").new()
	if not _expect(is_equal_approx(float(speech_reload.data["settings"].get("speech_rate", 1.0)), 1.1), "Speech speed preference did not persist across reload."):
		return
	instance.call("_on_nav_pressed", "Receiver")
	instance.call("_select_event", "SIG-0004")
	if not _expect(_tree_contains_text(instance, "PLAY SIGNAL AUDIO") and _tree_contains_text(instance, "READ TEXT"), "Receiver does not expose signal playback and separate transcript readout."):
		return
	instance.call("_on_nav_pressed", "Recordings")
	if not _expect(_tree_contains_text(instance, "PLAY SIGNAL AUDIO") and _tree_contains_text(instance, "READ TEXT"), "Recordings does not expose signal playback and separate transcript readout."):
		return
	print("DEAD AIR UI flow test passed: report submission/history/citations and notebook source labels/navigation with interpretation preserved.")
	quit(0)

func _tree_contains_text(node: Node, expected: String) -> bool:
	if node is Label and String((node as Label).text).contains(expected):
		return true
	if node is Button and String((node as Button).text).contains(expected):
		return true
	for child in node.get_children():
		if _tree_contains_text(child, expected):
			return true
	return false

func _expect(condition: bool, message: String) -> bool:
	if not condition:
		push_error(message)
		quit(1)
		return false
	return true
