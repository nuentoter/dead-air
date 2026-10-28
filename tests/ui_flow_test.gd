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
	instance.call("_submit_report")
	assert(game.data.get("reports", []).size() == initial_report_count, "A-006 should block submission until required records are reviewed.")
	instance.call("_on_nav_pressed", "Archive")
	for document_id in ["M-02", "M-05", "M-07", "M-08", "M-09"]:
		instance.call("_select_document", document_id)
	instance.call("_on_nav_pressed", "Assignments")
	instance.call("_select_assignment", "A-006")
	await process_frame
	instance.call("_on_report_source_toggled", false, "SIG-0004")
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
	print("DEAD AIR UI flow test passed: navigate, compose report, submit, close assignment, preserve unresolved case.")
	quit(0)

func _expect(condition: bool, message: String) -> bool:
	if not condition:
		push_error(message)
		quit(1)
		return false
	return true
