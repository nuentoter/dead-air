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
	instance.call("_on_nav_pressed", "Archive")
	for document_id in ["M-02", "M-05", "M-07", "M-08", "M-09"]:
		instance.call("_select_document", document_id)
	instance.call("_on_nav_pressed", "Assignments")
	instance.call("_select_assignment", "A-006")
	await process_frame
	var editor = instance.get("report_editor") as TextEdit
	if editor == null:
		push_error("A-006 report editor was not constructed.")
		quit(1)
		return
	editor.text = "UI test: M-07 and M-08 timestamps conflict; source-clock basis remains unknown."
	instance.call("_submit_report")
	await process_frame
	var game = instance.get("game")
	var reports: Array = game.data.get("reports", [])
	assert(not reports.is_empty(), "UI submission did not create a report.")
	assert(String(reports[-1].get("body", "")).begins_with("UI test:"), "UI submission body was not preserved.")
	assert(String(game.data["assignments"]["A-006"]) == "CLOSED", "UI submission did not close A-006.")
	assert(String(game.data["current_section"]) == "Messages", "UI submission should open Messages.")
	assert(String(reports[-1].get("case_status", "")) == "UNRESOLVED", "UI submission must leave the case unresolved.")
	print("DEAD AIR UI flow test passed: navigate, compose report, submit, close assignment, preserve unresolved case.")
	quit(0)
