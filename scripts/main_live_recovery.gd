extends "res://scripts/main_recovery.gd"
## Live synthetic waterfall layer over the Android-confirmed recovery controller.
## No changes to evidence, receiver save schema, or the recovery base.
const LiveSpectrum = preload("res://scripts/receiver_waterfall.gd")

var live_plot: Control
var live_trace: Array[PackedFloat32Array] = []
var live_channel := ""

func _process(delta: float) -> void:
	super._process(delta)
	_sync_live_plot()

func _refresh() -> void:
	if live_plot != null and is_instance_valid(live_plot):
		live_trace.clear()
		for row in live_plot.get("rows"):
			live_trace.append(row)
	live_plot = null
	super._refresh()

func _draw_waterfall() -> void:
	var frame := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.018, 0.035, 0.04, 1.0)
	style.set_corner_radius_all(5)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	frame.add_theme_stylebox_override("panel", style)
	body.add_child(frame)
	var panel := VBoxContainer.new()
	frame.add_child(panel)
	_add_text("LIVE WATERFALL  /  SYNTHETIC RECEIVER  /  NEWEST AT TOP", 12, ACCENT, panel)
	live_plot = LiveSpectrum.new()
	live_plot.name = "LiveRecoveryWaterfall"
	live_plot.custom_minimum_size = Vector2(0.0, 190.0)
	live_plot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	live_plot.set("rows", live_trace.duplicate())
	panel.add_child(live_plot)
	_sync_live_plot()
	_add_text("Animated while receiver is on. Tuned catalog signals are simulated; no live RF or new evidence.", 11, MUTED, panel)

func _sync_live_plot() -> void:
	if game == null or live_plot == null or not is_instance_valid(live_plot):
		return
	var frequency := float(game.data.get("frequency_mhz", 10.0))
	var mode := String(game.data.get("mode", "AM"))
	var channel := "%.3f/%s" % [frequency, mode]
	if channel != live_channel:
		live_channel = channel
		live_trace.clear()
		live_plot.call("clear_history")
	var strength := 0.0
	for event in Catalog.EVENTS:
		if String(event.get("mode", "")) == mode and absf(float(event.get("frequency_mhz", -1.0)) - frequency) < 0.0005:
			strength = maxf(strength, clampf(float(event.get("strength", 0.5)), 0.0, 1.0))
	live_plot.set("frequency_mhz", frequency)
	live_plot.set("signal_strength", strength)
	live_plot.set("powered", bool(game.data.get("receiver_power", false)))
