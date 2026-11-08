extends SceneTree
## Isolated live-waterfall recovery test. Stable fallback remains unchanged.
func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://scenes/main_live_recovery.tscn")
	if scene == null:
		push_error("LIVE FAIL: live recovery scene unavailable")
		quit(1)
		return
	var app: Control = scene.instantiate()
	if app == null or not app.has_method("_sync_live_plot"):
		push_error("LIVE FAIL: live controller failed to attach")
		quit(1)
		return
	root.add_child(app)
	await process_frame
	app.call("_on_nav_pressed", "Receiver")
	var plot: Control = app.find_child("LiveRecoveryWaterfall", true, false) as Control
	if plot == null:
		push_error("LIVE FAIL: waterfall not mounted in standard receiver")
		quit(1)
		return
	var game_state = app.get("game")
	if game_state == null:
		push_error("LIVE FAIL: standard game state unavailable")
		quit(1)
		return
	game_state.set_receiver(true, 14.070, "USB")
	app.call("_sync_live_plot")
	if not bool(plot.get("powered")):
		push_error("LIVE FAIL: display remained powered off")
		quit(1)
		return
	if absf(float(plot.get("frequency_mhz")) - 14.070) > 0.0005 or float(plot.get("signal_strength")) <= 0.0:
		push_error("LIVE FAIL: tuned authored signal not detected")
		quit(1)
		return
	await create_timer(0.35).timeout
	var initial_rows: int = (plot.get("rows") as Array).size()
	if initial_rows < 2:
		push_error("LIVE FAIL: waterfall did not scroll")
		quit(1)
		return
	app.call("_refresh")
	var refreshed: Control = app.find_child("LiveRecoveryWaterfall", true, false) as Control
	if refreshed == null or (refreshed.get("rows") as Array).size() < initial_rows:
		push_error("LIVE FAIL: history was lost during receiver refresh")
		quit(1)
		return
	game_state.set_receiver(false, 14.070, "USB")
	app.call("_sync_live_plot")
	var paused_rows: int = (refreshed.get("rows") as Array).size()
	await create_timer(0.22).timeout
	if bool(refreshed.get("powered")) or (refreshed.get("rows") as Array).size() != paused_rows:
		push_error("LIVE FAIL: waterfall continued to advance with RX off")
		quit(1)
		return
	print("PASS: live recovery receiver mounted, scrolled, retained history, and stopped with power")
	quit(0)
