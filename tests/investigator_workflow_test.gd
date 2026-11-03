extends SceneTree
## Android investigation smoke test, intentionally independent of illustrated receiver.
func _initialize() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> bool:
	if not ok:
		push_error(message)
		quit(1)
	return ok

func _run() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if not _check(packed != null, "Main scene missing"):
		return
	var app: Control = packed.instantiate()
	root.add_child(app)
	await process_frame
	var game = app.get("game")
	if not _check(game != null, "Game state unavailable"):
		return
	app.call("_on_nav_pressed", "Receiver")
	if not _check(not (app.get("illustrated_receiver") as Control).visible, "Standard receiver did not remain active"):
		return
	app.call("_clear_session_marks")
	app.call("_toggle_receiver_details")
	if not _check(bool(app.get("receiver_details_expanded")), "Waterfall expansion did not work"):
		return
	app.call("_toggle_receiver_details")
	if not _check(not bool(app.get("receiver_details_expanded")), "Waterfall collapse did not work"):
		return
	app.call("_toggle_session_mark", "SIG-0001")
	app.call("_toggle_session_mark", "SIG-0003")
	if not _check((app.get("session_signal_marks") as Array).size() == 2, "Mark selection failed"):
		return
	if not _check((game.data.get("investigator_signal_marks", []) as Array).size() == 2, "Marks were not saved in game data"):
		return
	var reloaded_state = load("res://scripts/game_state.gd").new()
	if not _check((reloaded_state.data.get("investigator_signal_marks", []) as Array).size() == 2, "Investigator marks did not survive save/reload"):
		return
	var notes_before: int = game.data.get("notes", []).size()
	app.call("_save_comparison_note")
	var notes: Array = game.data.get("notes", [])
	if not _check(notes.size() == notes_before + 1, "Comparison note was not saved"):
		return
	var note: Dictionary = notes[-1]
	if not _check(String(note.get("classification", "")) == "WORKING HYPOTHESIS", "Comparison classification not preserved"):
		return
	if not _check(String(note.get("source_id", "")) == "SIG-0001", "Comparison source link missing"):
		return
	if not _check(String(note.get("text", "")).contains("SIG-0003"), "Comparison note missing second signal"):
		return
	app.call("_open_investigator_notebook")
	if not _check(String(game.data.get("current_section", "")) == "Notebook", "Notebook navigation failed"):
		return
	app.call("_open_note_source", "SIG-0001")
	if not _check(String(game.data.get("selected_event_id", "")) == "SIG-0001", "Notebook source navigation failed"):
		return
	app.call("_clear_session_marks")
	if not _check((game.data.get("investigator_signal_marks", []) as Array).is_empty(), "Clear did not update saved selections"):
		return
	print("PASS: investigator marks, comparison notes, and source navigation")
	quit(0)
