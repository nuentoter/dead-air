extends Control
## Android workstation: every interactive area follows the photographed controls.
## Authoritative records, receiver settings and recording flow live in main.gd.
const MASTER = preload("res://gui/working_v2/dead_air_gui_v2/assets/master.png")
const REFERENCE := Vector2(1672.0, 941.0)
const GREEN := Color(0.68, 1.0, 0.73)
const DARK := Color(0.005, 0.033, 0.020, 0.97)

var host: Control
var rig: Control
var header_label: Label
var freq_label: Label
var event_label: Label
var signal_label: Label
var feedback_label: Label
var recording_button: Button
var power_button: Button
var step_hz := 100
var hold_display := false
var waterfall_mode := "LIVE"
var analysis_panel: PanelContainer
var analysis_label: Label
var analysis_visible := false
var _clock := 0.0
var _dial_down := false
var _dial_dragged := false
var _dial_total := 0.0

func setup(main_control: Control) -> void:
	host = main_control
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()
	resized.connect(_layout_rig)
	call_deferred("_layout_rig")

func _layout_rig() -> void:
	if rig == null:
		return
	var factor := minf(size.x / REFERENCE.x, size.y / REFERENCE.y)
	rig.scale = Vector2(factor, factor)
	rig.position = (size - REFERENCE * factor) / 2.0

func _mask(area: Rect2, color: Color = DARK) -> ColorRect:
	var rect := ColorRect.new()
	rect.position = area.position
	rect.size = area.size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rig.add_child(rect)
	return rect

func _readout(area: Rect2, font_size: int, centered: bool = false) -> Label:
	var label := Label.new()
	label.position = area.position
	label.size = area.size
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if centered:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", GREEN)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rig.add_child(label)
	return label

func _build() -> void:
	_mask_full_background()
	rig = Control.new()
	rig.name = "IllustratedRig"
	rig.size = REFERENCE
	rig.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(rig)
	var art := TextureRect.new()
	art.texture = MASTER
	art.size = REFERENCE
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rig.add_child(art)

	# Cover *baked* unrelated Blackwood content and decorative readouts.
	# Labels are set from the authoritative Godot save, not CSS browser demo values.
	_mask(Rect2(485, 91, 670, 45))
	header_label = _readout(Rect2(497, 92, 647, 42), 21)
	_mask(Rect2(298, 201, 182, 201))
	event_label = _readout(Rect2(310, 211, 162, 145), 20)
	_mask(Rect2(1264, 635, 276, 67))
	freq_label = _readout(Rect2(1274, 641, 257, 51), 31, true)
	_mask(Rect2(504, 140, 606, 62), Color(0.002, 0.025, 0.016, 0.91))
	signal_label = _readout(Rect2(518, 144, 580, 50), 19)
	feedback_label = _readout(Rect2(310, 360, 162, 37), 14)

	# Real left-side navigation: 8 pictured buttons, not 6 misaligned zones.
	# RADIO is also the physical power control. Case Files opens assignments.
	power_button = _hit("RADIO / POWER", Rect2(100, 164, 166, 50), _power)
	_hit("CASE FILES / ASSIGNMENTS", Rect2(100, 222, 166, 49), _navigate.bind("Assignments"))
	_hit("EVIDENCE / ARCHIVE", Rect2(100, 278, 166, 50), _navigate.bind("Archive"))
	_hit("RECORDINGS", Rect2(100, 335, 166, 49), _navigate.bind("Recordings"))
	_hit("TIMELINE / CHRONOLOGY", Rect2(100, 392, 166, 49), _open_timeline)
	_hit("MAP / SITE INDEX", Rect2(100, 449, 166, 49), _open_map)
	_hit("ARCHIVE", Rect2(100, 507, 166, 49), _navigate.bind("Archive"))
	_hit("NOTES", Rect2(100, 565, 166, 50), _navigate.bind("Notebook"))

	# Bottom-center photographed instrument switches.
	_hit("SEEK / SCAN", Rect2(497, 606, 104, 102), _seek)
	_hit("HOLD DISPLAY", Rect2(616, 606, 106, 102), _hold)
	recording_button = _hit("RECORD / STOP", Rect2(729, 606, 111, 102), _record)
	_hit("MARK CURRENT EVENT", Rect2(850, 606, 109, 102), _mark)
	_hit("ANALYZE", Rect2(969, 606, 110, 102), _analyze)

	# The five photographed modulation buttons (not a cycle button elsewhere).
	for item in [
		["AM", 630], ["LSB", 655], ["USB", 679],
		["CW", 704], ["FM", 729]
	]:
		_hit("MODE " + String(item[0]), Rect2(310, int(item[1]), 119, 24), _set_mode.bind(String(item[0])))
	# Right-hand physical tuning steps, matching the labels in the artwork.
	for entry in [
		[10000, 381], [1000, 434], [100, 487], [10, 541]
	]:
		_hit("STEP " + str(entry[0]) + " Hz", Rect2(1515, int(entry[1]), 93, 45), _set_step.bind(int(entry[0])))

	# On-photo RF/AF/SQUELCH knobs: tap to change their saved simulated
	# audio controls. Their visible instrument readout reflects each change.
	_hit("RF GAIN", Rect2(1245, 217, 108, 115), _adjust_knob.bind("rf_gain"))
	_hit("AF GAIN", Rect2(1360, 217, 106, 115), _adjust_knob.bind("af_gain"))
	_hit("SQUELCH", Rect2(1494, 217, 109, 115), _adjust_knob.bind("squelch"))
	_hit("AGC", Rect2(977, 97, 83, 39), _toggle_feature.bind("agc"))
	_hit("NB", Rect2(1065, 97, 93, 39), _toggle_feature.bind("nb"))
	for item in [["LIVE", 608], ["HISTORY", 640], ["PEAK", 672], ["AVERAGE", 702]]:
		_hit("WATERFALL " + String(item[0]), Rect2(1100, int(item[1]), 120, 28), _select_waterfall_mode.bind(String(item[0])))

	# Tuning dial: tap left/right side or swipe/drag to tune. A real touch
	# drag is handled by gui_input; there are no invisible off-knob +/- zones.
	var dial := Control.new()
	dial.name = "TuningDial"
	dial.position = Vector2(1250, 368)
	dial.size = Vector2(265, 264)
	dial.mouse_filter = Control.MOUSE_FILTER_STOP
	dial.gui_input.connect(_dial_input)
	rig.add_child(dial)

	# An on-radio analysis pane, only when ANALYZE is tapped.
	analysis_panel = PanelContainer.new()
	analysis_panel.name = "RadioAnalysis"
	analysis_panel.position = Vector2(492, 205)
	analysis_panel.size = Vector2(622, 387)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.006, 0.039, 0.024, 0.98)
	style.border_color = Color(0.38, 0.72, 0.50)
	style.set_border_width_all(3)
	style.set_content_margin_all(15)
	analysis_panel.add_theme_stylebox_override("panel", style)
	rig.add_child(analysis_panel)
	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 10)
	analysis_panel.add_child(contents)
	analysis_label = Label.new()
	analysis_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	analysis_label.custom_minimum_size = Vector2(560, 264)
	analysis_label.add_theme_color_override("font_color", GREEN)
	analysis_label.add_theme_font_size_override("font_size", 22)
	contents.add_child(analysis_label)
	var actions := HBoxContainer.new()
	contents.add_child(actions)
	_action(actions, "PLAY SIGNAL", _play_signal)
	_action(actions, "READ TEXT", _read_signal)
	_action(actions, "CLOSE", _close_analysis)
	analysis_panel.visible = false
	refresh_from_game()

func _mask_full_background() -> void:
	var shade := ColorRect.new()
	shade.color = Color(0.012, 0.016, 0.015)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

func _action(parent: HBoxContainer, caption: String, handler: Callable) -> void:
	var button := Button.new()
	button.text = caption
	button.custom_minimum_size = Vector2(155, 57)
	button.add_theme_font_size_override("font_size", 19)
	button.pressed.connect(handler)
	parent.add_child(button)

func _hit(caption: String, area: Rect2, handler: Callable) -> Button:
	var button := Button.new()
	button.name = "Hit_" + caption.replace(" ", "_").replace("/", "_")
	button.text = ""
	button.tooltip_text = caption
	button.position = area.position
	button.size = area.size
	button.focus_mode = Control.FOCUS_ALL
	var unlit := StyleBoxFlat.new()
	unlit.bg_color = Color.TRANSPARENT
	unlit.border_color = Color.TRANSPARENT
	button.add_theme_stylebox_override("normal", unlit)
	var over := StyleBoxFlat.new()
	over.bg_color = Color(0.1, 0.5, 0.23, 0.15)
	over.border_color = Color(0.54, 0.95, 0.62)
	over.set_border_width_all(2)
	button.add_theme_stylebox_override("hover", over)
	button.add_theme_stylebox_override("focus", over)
	button.add_theme_stylebox_override("pressed", over)
	button.pressed.connect(handler)
	rig.add_child(button)
	return button

func _process(delta: float) -> void:
	if not visible or host == null or host.game == null:
		return
	_clock += delta
	if _clock > 0.16:
		_clock = 0.0
		refresh_from_game()

func refresh_from_game() -> void:
	if host == null or host.game == null or header_label == null:
		return
	var data: Dictionary = host.game.data
	var on := bool(data.get("receiver_power", false))
	var mode := String(data.get("mode", "AM"))
	var freq := float(data.get("frequency_mhz", 10.0))
	var event_id := String(data.get("selected_event_id", "SIG-0001"))
	var event: Dictionary = host._find_event(event_id)
	var controls: Dictionary = data.get("receiver_controls", {})
	header_label.text = ("RX ON" if on else "RX OFF") + "   SITE 04   " + mode + "   " + _step_name() + " STEP   AGC " + ("ON" if bool(controls.get("agc", true)) else "OFF") + "   NB " + ("ON" if bool(controls.get("nb", true)) else "OFF")
	freq_label.text = "%.3f MHz" % freq
	event_label.text = "NRMS  SITE 04\n\nRETAINED RECORD\n" + event_id + "\n" + String(event.get("time_label", "--")) + "\n" + String(event.get("identifier", ""))
	signal_label.text = String(event.get("kind", "UNKNOWN")) + " / " + waterfall_mode + (" / HOLD" if hold_display else "") + "\nRF %d   AF %d   SQ %d   " % [int(controls.get("rf_gain", 55)), int(controls.get("af_gain", 55)), int(controls.get("squelch", 20))] + ("RECORDING" if host.monitor_capture.is_recording() else "MONITOR")
	feedback_label.text = host.status_message.left(52)
	recording_button.tooltip_text = "STOP MONITOR RECORDING" if host.monitor_capture.is_recording() else "RECORD MONITOR (+30s)"
	if analysis_visible:
		analysis_label.text = "SITE 04 / SIGNAL ANALYSIS\n\n" + event_id + "     " + String(event.get("kind", "")) + "\n" + str(event.get("frequency_mhz", "")) + " MHz  /  " + String(event.get("mode", "")) + "\n\n" + String(event.get("transcript", "")) + "\n\nProvenance: " + String(event.get("provenance", ""))

func _step_name() -> String:
	if step_hz >= 1000:
		return str(step_hz / 1000) + " kHz"
	return str(step_hz) + " Hz"

func _navigate(section: String) -> void:
	analysis_visible = false
	analysis_panel.visible = false
	host._on_nav_pressed(section)

func _power() -> void:
	host._toggle_receiver()
	refresh_from_game()

func _seek() -> void:
	host._seek_next()
	refresh_from_game()

func _set_step(new_step: int) -> void:
	step_hz = new_step
	host.status_message = "Tuning step: " + _step_name()
	refresh_from_game()

func _cycle_step() -> void:
	var steps := [10, 100, 1000, 10000]
	step_hz = steps[(steps.find(step_hz) + 1) % steps.size()]
	refresh_from_game()

func _set_mode(new_mode: String) -> void:
	var current := String(host.game.data.get("mode", "AM"))
	if current == new_mode:
		return
	host._finish_monitor_recording("INTERRUPTED_TUNE")
	host.monitor_capture.retune(float(host.game.data.get("frequency_mhz", 10.0)), new_mode)
	host.game.set_receiver(bool(host.game.data.get("receiver_power", false)), float(host.game.data.get("frequency_mhz", 10.0)), new_mode)
	host.status_message = "Mode set to " + new_mode + "."
	refresh_from_game()

func _cycle_mode() -> void:
	var modes := ["AM", "LSB", "USB", "CW", "FM", "NFM"]
	var current := String(host.game.data.get("mode", "AM"))
	_set_mode(String(modes[(modes.find(current) + 1) % modes.size()]))

func _tune(steps: int) -> void:
	if not bool(host.game.data.get("receiver_power", false)):
		host.status_message = "Power on the receiver using RADIO."
		refresh_from_game()
		return
	var frequency := float(host.game.data.get("frequency_mhz", 10.0))
	var next_frequency := clampf(frequency + float(steps * step_hz) / 1000000.0, 0.1, 30000.0)
	if absf(frequency - next_frequency) < 0.0000001:
		return
	host._finish_monitor_recording("INTERRUPTED_TUNE")
	host.monitor_capture.retune(next_frequency, String(host.game.data.get("mode", "AM")))
	host.game.set_receiver(true, next_frequency, String(host.game.data.get("mode", "AM")))
	host.status_message = "Tuned to %.6f MHz." % next_frequency
	refresh_from_game()

func _dial_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_dial_down = true
			_dial_dragged = false
			_dial_total = 0.0
		elif _dial_down:
			_dial_down = false
			if not _dial_dragged:
				_tune(1 if event.position.x > 132.5 else -1)
	elif event is InputEventScreenDrag and _dial_down:
		_dial_total += event.relative.x - event.relative.y
		_apply_drag()
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_tune(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_tune(-1)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_dial_down = true
				_dial_dragged = false
				_dial_total = 0.0
			elif _dial_down:
				_dial_down = false
				if not _dial_dragged:
					_tune(1 if event.position.x > 132.5 else -1)
	elif event is InputEventMouseMotion and _dial_down:
		_dial_total += event.relative.x - event.relative.y
		_apply_drag()

func _apply_drag() -> void:
	var moves := int(_dial_total / 11.0)
	if moves == 0:
		return
	_dial_dragged = true
	_dial_total -= float(moves) * 11.0
	_tune(moves)

func _adjust_knob(name: String) -> void:
	var controls: Dictionary = host.game.data.get("receiver_controls", {})
	var current := int(controls.get(name, 50))
	var next_value := (current + 10) % 110
	host._set_receiver_control(name, next_value)
	host.status_message = name.to_upper().replace("_", " ") + ": " + str(next_value) + "%"
	refresh_from_game()

func _toggle_feature(name: String) -> void:
	var controls: Dictionary = host.game.data.get("receiver_controls", {})
	var next_value := not bool(controls.get(name, true))
	host._set_receiver_control(name, next_value)
	host.status_message = name.to_upper() + (" ON" if next_value else " OFF") + " (synthetic monitor)"
	refresh_from_game()

func _select_waterfall_mode(mode: String) -> void:
	waterfall_mode = mode
	host.status_message = "Waterfall " + mode + " selected. Photograph is static in this test build."
	refresh_from_game()

func _hold() -> void:
	hold_display = not hold_display
	host.status_message = "Display HOLD selected (waterfall artwork is static in this test build)." if hold_display else "Display HOLD cleared."
	refresh_from_game()

func _record() -> void:
	if host.monitor_capture.is_recording():
		host._stop_monitor_recording()
	else:
		host._start_monitor_recording()
	refresh_from_game()

func _mark() -> void:
	var event_id := String(host.game.data.get("selected_event_id", ""))
	host.game.record_event(event_id)
	host.status_message = "Event " + event_id + " annotated. Institutional source unchanged."
	refresh_from_game()

func _analyze() -> void:
	analysis_visible = not analysis_visible
	analysis_panel.visible = analysis_visible
	refresh_from_game()

func _close_analysis() -> void:
	analysis_visible = false
	analysis_panel.visible = false

func _play_signal() -> void:
	host._play_selected_signal()
	refresh_from_game()

func _read_signal() -> void:
	host._speak_selected_transcript()
	refresh_from_game()

func _open_timeline() -> void:
	host._on_nav_pressed("Archive")
	host._select_document("M-07")

func _open_map() -> void:
	host.status_message = "Map is not yet an implemented game system. Available site records can be found in Archive."
	host._on_nav_pressed("Archive")
