extends Control
## Illustrated receiver shell. Uses the same GameState and main.gd actions as the
## accessible work panels; this is not a second browser-only simulation.
const MASTER = preload("res://gui/working_v2/dead_air_gui_v2/assets/master.png")
const REFERENCE := Vector2(1672.0, 941.0)
const GREEN := Color(0.68, 1.0, 0.73)
const DIM := Color(0.46, 0.68, 0.57)
const PANEL := Color(0.006, 0.035, 0.025, 0.94)

var host: Control
var rig: Control
var freq_label: Label
var detail_label: Label
var header_label: Label
var event_label: Label
var recording_button: Button
var power_button: Button
var selected_mode := "AM"
var _refresh_clock := 0.0
var quick_panel: PanelContainer
var step_hz := 1000

func setup(main_control: Control) -> void:
	host = main_control
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	resized.connect(_layout_rig)
	call_deferred("_layout_rig")

func _layout_rig() -> void:
	if rig == null:
		return
	var factor := minf(size.x / REFERENCE.x, size.y / REFERENCE.y)
	rig.scale = Vector2(factor, factor)
	rig.position = (size - REFERENCE * factor) / 2.0

func _build() -> void:
	var shade := ColorRect.new()
	shade.color = Color(0.008, 0.014, 0.014)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	rig = Control.new()
	rig.name = "IllustratedRig"
	rig.size = REFERENCE
	rig.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(rig)

	var image := TextureRect.new()
	image.texture = MASTER
	image.position = Vector2.ZERO
	image.size = REFERENCE
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rig.add_child(image)

	header_label = _readout(Rect2(514, 99, 658, 34), 23)
	freq_label = _readout(Rect2(1280, 646, 255, 52), 30)
	detail_label = _readout(Rect2(518, 147, 600, 75), 19)
	event_label = _readout(Rect2(304, 226, 170, 170), 18)

	var nav_names := ["RADIO", "ASSIGNMENTS", "ARCHIVE", "RECORDINGS", "NOTEBOOK", "MESSAGES"]
	var nav_targets := ["Receiver", "Assignments", "Archive", "Recordings", "Notebook", "Messages"]
	for i in range(nav_names.size()):
		var area := Rect2(99, 163 + i * 69, 174, 57)
		_hit(nav_names[i], area, _navigate.bind(nav_targets[i]))

	power_button = _hit("POWER", Rect2(291, 152, 186, 44), _power)
	_hit("SCAN / SEEK NEXT", Rect2(497, 607, 104, 103), _seek)
	_hit("MARK RETAINED EVENT", Rect2(848, 606, 113, 102), _mark)
	recording_button = _hit("RECORD MONITOR AUDIO", Rect2(729, 606, 111, 102), _record)
	_hit("PLAY SYNTHETIC SIGNAL", Rect2(968, 605, 114, 103), _play_signal)
	_hit("TUNE DOWN", Rect2(1238, 390, 92, 120), _tune.bind(-1))
	_hit("TUNE UP", Rect2(1398, 390, 94, 120), _tune.bind(1))

	var controls := _panel(Rect2(290, 760, 1150, 124))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 9)
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.offset_left = 14
	row.offset_top = 10
	row.offset_right = -14
	row.offset_bottom = -10
	controls.add_child(row)
	_action(row, "TUNE −", _tune.bind(-1))
	_action(row, "TUNE +", _tune.bind(1))
	_action(row, "MODE", _cycle_mode)
	_action(row, "STEP", _cycle_step)
	_action(row, "SEEK", _seek)
	_action(row, "RECORD", _record)
	_action(row, "PLAY", _play_signal)
	_action(row, "WORK PANELS", _navigate.bind("Assignments"))

	quick_panel = _panel(Rect2(292, 415, 840, 175))
	quick_panel.visible = false
	var quick_text := Label.new()
	quick_text.text = "Illustrated receiver: all signals and evidence come from the Godot catalog. Use WORK PANELS for reports, archive and notes. The recorder stores locally generated monitor audio, not RF reception."
	quick_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	quick_text.add_theme_font_size_override("font_size", 22)
	quick_text.add_theme_color_override("font_color", GREEN)
	quick_panel.add_child(quick_text)

func _panel(area: Rect2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = area.position
	panel.size = area.size
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL
	style.border_color = Color(0.3, 0.62, 0.44)
	style.set_border_width_all(2)
	style.set_content_margin_all(9)
	panel.add_theme_stylebox_override("panel", style)
	rig.add_child(panel)
	return panel

func _readout(area: Rect2, font_size: int) -> Label:
	var label := Label.new()
	label.position = area.position
	label.size = area.size
	label.add_theme_color_override("font_color", GREEN)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.2, 0.08, 0.95))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rig.add_child(label)
	return label

func _hit(label: String, area: Rect2, callback: Callable) -> Button:
	var button := Button.new()
	button.text = ""
	button.tooltip_text = label
	button.accessibility_name = label
	button.position = area.position
	button.size = area.size
	button.focus_mode = Control.FOCUS_ALL
	var clear_style := StyleBoxFlat.new()
	clear_style.bg_color = Color.TRANSPARENT
	clear_style.border_color = Color.TRANSPARENT
	button.add_theme_stylebox_override("normal", clear_style)
	var highlight := StyleBoxFlat.new()
	highlight.bg_color = Color(0.2, 0.5, 0.3, 0.16)
	highlight.border_color = GREEN
	highlight.set_border_width_all(2)
	button.add_theme_stylebox_override("hover", highlight)
	button.add_theme_stylebox_override("focus", highlight)
	button.add_theme_stylebox_override("pressed", highlight)
	button.pressed.connect(callback)
	rig.add_child(button)
	return button

func _action(parent: HBoxContainer, title: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = title
	button.custom_minimum_size = Vector2(106, 72)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(callback)
	parent.add_child(button)

func _process(delta: float) -> void:
	if not visible or host == null or host.game == null:
		return
	_refresh_clock += delta
	if _refresh_clock < 0.2:
		return
	_refresh_clock = 0.0
	refresh_from_game()

func refresh_from_game() -> void:
	if host == null or host.game == null or header_label == null:
		return
	var state: Dictionary = host.game.data
	var on := bool(state.get("receiver_power", false))
	var mode := String(state.get("mode", "AM"))
	var frequency := float(state.get("frequency_mhz", 10.0))
	var selected_id := String(state.get("selected_event_id", "SIG-0001"))
	header_label.text = ("RX ON" if on else "RX OFF") + "  /  SITE 04  /  " + mode + "  /  " + str(step_hz) + " Hz STEP"
	freq_label.text = "%.3f MHz" % frequency
	var event: Dictionary = host._find_event(selected_id)
	detail_label.text = "RETAINED: " + selected_id + "     " + String(event.get("kind", "UNKNOWN")) + "\n" + "MODE " + mode + "  •  " + ("RECORDING" if host.monitor_capture.is_recording() else "MONITOR READY")
	event_label.text = "NRMS\nSITE 04\n" + selected_id + "\n" + String(event.get("time_label", "--")) + "\n" + String(event.get("identifier", ""))
	recording_button.tooltip_text = "STOP MONITOR RECORDING" if host.monitor_capture.is_recording() else "RECORD MONITOR (+30s PRE-ROLL)"
	power_button.tooltip_text = "POWER OFF" if on else "POWER ON"

func _navigate(section: String) -> void:
	if section == "Receiver":
		refresh_from_game()
		return
	host._on_nav_pressed(section)

func _power() -> void:
	host._toggle_receiver()
	refresh_from_game()

func _seek() -> void:
	host._seek_next()
	refresh_from_game()

func _tune(sign: int) -> void:
	if not bool(host.game.data.get("receiver_power", false)):
		host.status_message = "Power on the receiver before tuning."
		return
	var next_frequency: float = clampf(float(host.game.data.get("frequency_mhz", 10.0)) + float(sign * step_hz) / 1000000.0, 0.1, 30000.0)
	host._finish_monitor_recording("INTERRUPTED_TUNE")
	host.monitor_capture.retune(next_frequency, String(host.game.data.get("mode", "AM")))
	host.game.set_receiver(true, next_frequency, String(host.game.data.get("mode", "AM")))
	host.status_message = "Tuned to %.3f MHz. Retained source record not altered." % next_frequency
	refresh_from_game()

func _cycle_step() -> void:
	var options := [10, 100, 1000, 10000]
	step_hz = options[(options.find(step_hz) + 1) % options.size()]
	refresh_from_game()

func _cycle_mode() -> void:
	var modes := ["AM", "USB", "LSB", "CW", "FM", "NFM"]
	var current := String(host.game.data.get("mode", "AM"))
	var next_mode: String = modes[(modes.find(current) + 1) % modes.size()]
	host._finish_monitor_recording("INTERRUPTED_TUNE")
	host.monitor_capture.retune(float(host.game.data.get("frequency_mhz", 10.0)), next_mode)
	host.game.set_receiver(bool(host.game.data.get("receiver_power", false)), float(host.game.data.get("frequency_mhz", 10.0)), next_mode)
	refresh_from_game()

func _record() -> void:
	if host.monitor_capture.is_recording():
		host._stop_monitor_recording()
	else:
		host._start_monitor_recording()
	refresh_from_game()

func _mark() -> void:
	var id := String(host.game.data.get("selected_event_id", ""))
	host.game.select_event(id)
	host.status_message = "Marked retained event " + id + " for review. This is not a new signal capture."
	refresh_from_game()

func _play_signal() -> void:
	host._play_selected_signal()
	refresh_from_game()
