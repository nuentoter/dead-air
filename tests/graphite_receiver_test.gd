extends SceneTree
## Headless regression for the graphite-and-green receiver.
func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	if scene == null:
		push_error("Main scene missing")
		quit(1)
		return
	var root_game: Control = scene.instantiate()
	root.add_child(root_game)
	await process_frame
	root_game.call("_on_nav_pressed", "Receiver")
	var receiver: Control = root_game.get_node_or_null("IllustratedReceiver")
	if receiver == null:
		push_error("Receiver not mounted")
		quit(1)
		return
	var rig: Node = receiver.get_node_or_null("IllustratedRig")
	if rig == null:
		push_error("Graphite chassis not mounted")
		quit(1)
		return
	for control_name in ["LiveWaterfall", "Hit_MODE_USB", "Hit_MODE_CW", "Hit_TUNE_DOWN", "Hit_TUNE_UP", "Hit_RECORD___STOP", "Hit_HOLD", "Hit_SCAN", "Hit_ARCHIVE", "Hit_NOTEBOOK", "Hit_TUNING_STEP"]:
		if rig.get_node_or_null(control_name) == null:
			push_error("Missing receiver control: " + control_name)
			quit(1)
			return
	receiver.call("_layout_rig")
	if (rig as Control).scale.x <= 0.01 or (rig as Control).scale.y <= 0.01:
		push_error("Illustrated receiver has a zero-sized viewport layout")
		quit(1)
		return
	var plot: Control = rig.get_node("LiveWaterfall")
	if plot.get("rows") == null or plot.size.x <= 0.0 or plot.size.y <= 0.0:
		push_error("Waterfall renderer was not initialized")
		quit(1)
		return
	var game = root_game.get("game")
	if not bool(game.data.get("receiver_power", false)):
		receiver.call("_power")
	receiver.call("_set_mode", "USB")
	receiver.call("refresh_from_game")
	var lamps: Dictionary = receiver.get("active_lights")
	if not lamps.has("USB") or not lamps.has("POWER"):
		push_error("Mode or power indicator missing")
		quit(1)
		return
	if (lamps["USB"] as ColorRect).color.g < 0.9 or (lamps["POWER"] as ColorRect).color.g < 0.9:
		push_error("Active receiver lamps did not illuminate")
		quit(1)
		return
	var previous_step: int = int(receiver.get("step_hz"))
	(rig.get_node("Hit_TUNING_STEP") as Button).pressed.emit()
	if int(receiver.get("step_hz")) == previous_step:
		push_error("Step selector did not cycle")
		quit(1)
		return
	receiver.call("_set_step", 1000)
	var old_frequency := float(game.data.get("frequency_mhz", 0.0))
	receiver.call("_tune", 1)
	if float(game.data.get("frequency_mhz", 0.0)) <= old_frequency:
		push_error("Tuning did not reach game state")
		quit(1)
		return
	receiver.call("_hold")
	if not bool(receiver.get("hold_display")):
		push_error("Hold did not activate")
		quit(1)
		return
	receiver.call("_hold")
	if bool(receiver.get("hold_display")):
		push_error("Hold did not deactivate")
		quit(1)
		return
	print("PASS: graphite receiver wiring and waterfall")
	quit(0)
