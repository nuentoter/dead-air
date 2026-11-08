extends SceneTree
## Recovery-release test: checks only the Android-confirmed standard UI.
func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://scenes/main_recovery.tscn")
	if scene == null:
		push_error("RECOVERY FAIL: standard game scene missing")
		quit(1)
		return
	var app: Control = scene.instantiate()
	root.add_child(app)
	await process_frame
	if not app.has_method("_on_nav_pressed") or not app.has_method("_refresh"):
		push_error("RECOVERY FAIL: missing main game controller methods")
		quit(1)
		return
	var state = app.get("game")
	if state == null:
		push_error("RECOVERY FAIL: save state not initialized")
		quit(1)
		return
	for section in ["Receiver", "Recordings", "Archive", "Notebook", "Assignments", "Messages"]:
		app.call("_on_nav_pressed", section)
		if String(state.data.get("current_section", "")) != section:
			push_error("RECOVERY FAIL: navigation to " + section)
			quit(1)
			return
	app.call("_on_nav_pressed", "Receiver")
	app.call("_toggle_receiver")
	if not bool(state.data.get("receiver_power", false)):
		push_error("RECOVERY FAIL: receiver could not power on")
		quit(1)
		return
	app.call("_tune_to_retained_event", "SIG-0003") if app.has_method("_tune_to_retained_event") else app.call("_select_event", "SIG-0003")
	if String(state.data.get("selected_event_id", "")) != "SIG-0003":
		push_error("RECOVERY FAIL: retained signal unavailable")
		quit(1)
		return
	app.call("_toggle_receiver")
	print("PASS: recovered Android receiver, records, and navigation")
	quit(0)
