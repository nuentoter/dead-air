extends SceneTree
## Checks that the standard Android waterfall advances in real time.
const LiveWaterfall = preload("res://scripts/receiver_waterfall.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	if scene == null:
		push_error("Main scene unavailable")
		quit(1)
		return
	var app: Control = scene.instantiate()
	root.add_child(app)
	await process_frame
	app.call("_on_nav_pressed", "Receiver")
	var plot: Control = app.get_node_or_null("LiveReceiverWaterfall")
	# The plot is nested within the standard receiver's content hierarchy.
	if plot == null:
		plot = app.find_child("LiveReceiverWaterfall", true, false) as Control
	if plot == null:
		push_error("Live standard receiver waterfall missing")
		quit(1)
		return
	var game = app.get("game")
	game.set_receiver(true, 14.070, "USB")
	app.call("_sync_live_waterfall")
	if not bool(plot.get("powered")) or absf(float(plot.get("frequency_mhz")) - 14.070) > 0.0005:
		push_error("Live waterfall did not receive game tuning/power state")
		quit(1)
		return
	var telemetry := app.find_child("LiveWaterfallTelemetry", true, false) as Label
	if telemetry == null or not telemetry.text.contains("14.070 MHz USB") or not telemetry.text.contains("SIG-0003"):
		push_error("Live waterfall telemetry did not show selected signal and tuning")
		quit(1)
		return
	if float(plot.get("signal_strength")) <= 0.0:
		push_error("Authored matching channel was not represented")
		quit(1)
		return
	await create_timer(0.35).timeout
	if (plot.get("rows") as Array).size() < 2:
		push_error("Live waterfall did not advance scrolling rows")
		quit(1)
		return
	# Holding and UI rebuilding must preserve visible history without generating new rows.
	var rows_before_hold: int = (plot.get("rows") as Array).size()
	app.call("_toggle_waterfall_hold")
	plot = app.find_child("LiveReceiverWaterfall", true, false) as Control
	if plot == null or (plot.get("rows") as Array).size() != rows_before_hold or not bool(plot.get("frozen")):
		push_error("HOLD did not preserve existing waterfall history")
		quit(1)
		return
	await create_timer(0.25).timeout
	if (plot.get("rows") as Array).size() != rows_before_hold:
		push_error("HOLD allowed synthetic waterfall to keep scrolling")
		quit(1)
		return
	app.call("_adjust_waterfall_gain", 0.25)
	plot = app.find_child("LiveReceiverWaterfall", true, false) as Control
	if plot == null or absf(float(plot.get("display_gain")) - 1.25) > 0.001:
		push_error("Display gain was not applied to recreated waterfall")
		quit(1)
		return
	app.call("_clear_waterfall_trace")
	if not (plot.get("rows") as Array).is_empty():
		push_error("CLEAR TRACE did not empty the display")
		quit(1)
		return
	app.call("_toggle_waterfall_hold")
	plot = app.find_child("LiveReceiverWaterfall", true, false) as Control
	await create_timer(0.23).timeout
	if (plot.get("rows") as Array).is_empty():
		push_error("RESUME did not restart the synthetic waterfall")
		quit(1)
		return
	game.set_receiver(false, 14.070, "USB")
	app.call("_sync_live_waterfall")
	if bool(plot.get("powered")):
		push_error("Waterfall did not switch off with receiver")
		quit(1)
		return
	var count: int = (plot.get("rows") as Array).size()
	await create_timer(0.25).timeout
	if (plot.get("rows") as Array).size() != count:
		push_error("Waterfall continued advancing with power off")
		quit(1)
		return
	print("PASS: live waterfall scroll, power gating, and tuned signal")
	quit(0)
