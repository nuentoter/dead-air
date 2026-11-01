extends Control

const Catalog = preload("res://scripts/content_catalog.gd")
const GameState = preload("res://scripts/game_state.gd")
const SpeechEngine = preload("res://scripts/speech_engine.gd")
const SignalAudioEngine = preload("res://scripts/signal_audio_engine.gd")

const SECTIONS = ["Receiver", "Recordings", "Archive", "Notebook", "Assignments", "Messages"]
const REPORT_SOURCE_OPTIONS := ["SIG-0004", "SIG-0005", "M-02", "M-05", "M-06A", "M-07", "M-08", "M-09"]
const BG = Color(0.035, 0.055, 0.065, 1)
const PANEL = Color(0.065, 0.095, 0.105, 1)
const PANEL_ALT = Color(0.085, 0.125, 0.135, 1)
const TEXT = Color(0.88, 0.92, 0.89, 1)
const MUTED = Color(0.57, 0.68, 0.67, 1)
const ACCENT = Color(0.45, 0.79, 0.65, 1)
const WARNING = Color(0.91, 0.72, 0.43, 1)

class WaterfallPlot extends Control:
	signal frequency_selected(frequency: float)
	signal event_selected(event_id: String)

	var events: Array = []
	var frequency_min := 3.0
	var frequency_max := 30.0
	var tuned_frequency := 10.0
	var history: Array = []
	var row_clock := 0.0
	var row_counter := 0
	var drag_active := false

	func _ready() -> void:
		custom_minimum_size = Vector2(0, 190)
		mouse_filter = Control.MOUSE_FILTER_STOP
		for row in range(64):
			history.append(_make_noise_row(row))
		queue_redraw()

	func _process(delta: float) -> void:
		row_clock += delta
		var added_row := false
		while row_clock >= 0.12:
			row_clock -= 0.12
			history.push_front(_make_noise_row(row_counter))
			row_counter += 1
			if history.size() > 64:
				history.pop_back()
			added_row = true
		if added_row:
			queue_redraw()

	func _make_noise_row(seed_value: int) -> PackedFloat32Array:
		var values := PackedFloat32Array()
		values.resize(96)
		for col in range(96):
			var wave := absf(sin(float(col) * 0.41 + float(seed_value) * 0.17) * cos(float(col) * 0.13 - float(seed_value) * 0.09))
			var noise := fposmod(sin(float(col * 37 + seed_value * 19) * 12.9898 + float(seed_value) * 78.233) * 43758.5453, 1.0)
			values[col] = clampf(0.07 + wave * 0.13 + noise * 0.12, 0.04, 0.32)
		return values

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_active = true
				_preview_at(event.position)
			elif drag_active:
				drag_active = false
				_select_at(event.position)
		elif event is InputEventMouseMotion and drag_active:
			if (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
				_preview_at(event.position)
		elif event is InputEventScreenTouch:
			if event.pressed:
				drag_active = true
				_preview_at(event.position)
			elif drag_active:
				drag_active = false
				_select_at(event.position)
		elif event is InputEventScreenDrag and drag_active:
			_preview_at(event.position)

	func _frequency_at(position: Vector2) -> float:
		var left := 44.0
		var right := maxf(left + 1.0, size.x - 4.0)
		var normalized := clampf((position.x - left) / (right - left), 0.0, 1.0)
		return lerpf(frequency_min, frequency_max, normalized)

	func _preview_at(position: Vector2) -> void:
		tuned_frequency = _frequency_at(position)
		queue_redraw()

	func _select_at(position: Vector2) -> void:
		tuned_frequency = _frequency_at(position)
		var nearest_id := ""
		var nearest_difference := INF
		for event_data in events:
			var event_id := String(event_data.get("id", ""))
			if not ["SIG-0001", "SIG-0002", "SIG-0003"].has(event_id):
				continue
			var event_frequency := float(event_data.get("frequency_mhz", 0.0))
			if event_frequency < frequency_min or event_frequency > frequency_max:
				continue
			var difference := absf(event_frequency - tuned_frequency)
			if difference < nearest_difference:
				nearest_difference = difference
				nearest_id = event_id
		var snap_threshold := (frequency_max - frequency_min) * 0.015
		if not nearest_id.is_empty() and nearest_difference <= snap_threshold:
			event_selected.emit(nearest_id)
		else:
			frequency_selected.emit(tuned_frequency)
		queue_redraw()

	func _draw() -> void:
		var font := ThemeDB.fallback_font
		var label_size := 10
		var left_gutter := 44.0
		var bottom_gutter := 18.0
		var plot_rect := Rect2(Vector2(left_gutter, 4.0), Vector2(maxf(1.0, size.x - left_gutter - 4.0), maxf(1.0, size.y - bottom_gutter - 4.0)))
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.018, 0.035, 0.04, 1), true)
		var cell_height := plot_rect.size.y / float(maxi(1, history.size()))
		var cell_width := plot_rect.size.x / 96.0
		for row in range(history.size()):
			var values: PackedFloat32Array = history[row]
			var y := plot_rect.position.y + float(row) * cell_height
			for col in range(values.size()):
				var intensity := values[col]
				var tint := Color(0.06 + intensity * 0.25, 0.12 + intensity * 0.75, 0.11 + intensity * 0.42, 1)
				draw_rect(Rect2(plot_rect.position.x + float(col) * cell_width, y, cell_width + 0.5, cell_height + 0.25), tint, true)
		for step in range(5):
			var x := plot_rect.position.x + plot_rect.size.x * float(step) / 4.0
			draw_line(Vector2(x, plot_rect.position.y), Vector2(x, plot_rect.end.y), Color(0.12, 0.2, 0.19, 1), 1.0)
			if step == 0 or step == 2 or step == 4:
				var frequency_label := "%.1f MHz" % lerpf(frequency_min, frequency_max, float(step) / 4.0)
				draw_string(font, Vector2(x - 18.0, size.y - 3.0), frequency_label, HORIZONTAL_ALIGNMENT_LEFT, 52.0, label_size, Color(0.57, 0.68, 0.67, 1))
		for minute in [0, 15, 30]:
			var y := plot_rect.position.y + plot_rect.size.y * float(minute) / 30.0
			draw_line(Vector2(plot_rect.position.x, y), Vector2(plot_rect.end.x, y), Color(0.16, 0.25, 0.23, 1), 1.0)
			var time_label := "08:%02d" % minute
			var label_y := clampf(y + 4.0, 12.0, size.y - bottom_gutter)
			draw_string(font, Vector2(2.0, label_y), time_label, HORIZONTAL_ALIGNMENT_LEFT, left_gutter - 5.0, label_size, Color(0.57, 0.68, 0.67, 1))
		for event_data in events:
			var event_id := String(event_data.get("id", ""))
			if not ["SIG-0001", "SIG-0002", "SIG-0003"].has(event_id):
				continue
			var parts: PackedStringArray = String(event_data.get("time_label", "08:00")).split(":")
			if parts.size() != 2:
				continue
			var minutes := int(parts[0]) * 60 + int(parts[1])
			var relative_minutes := clampf(float(minutes - 480), 0.0, 30.0)
			var frequency := float(event_data.get("frequency_mhz", 0.0))
			if frequency < frequency_min or frequency > frequency_max:
				continue
			var normalized_frequency := (frequency - frequency_min) / maxf(0.001, frequency_max - frequency_min)
			var x := plot_rect.position.x + plot_rect.size.x * normalized_frequency
			var y := plot_rect.position.y + plot_rect.size.y * relative_minutes / 30.0
			var strength := clampf(float(event_data.get("strength", 0.5)), 0.0, 1.0)
			var half_width := 5.0 + strength * 18.0
			var trace_color := Color(0.22, 0.48, 0.39, 1).lerp(Color(0.5, 0.88, 0.68, 1), strength)
			draw_line(Vector2(maxf(plot_rect.position.x, x - half_width), y), Vector2(minf(plot_rect.end.x, x + half_width), y), trace_color, 3.0)
			draw_line(Vector2(x, maxf(plot_rect.position.y, y - 4.0)), Vector2(x, minf(plot_rect.end.y, y + 4.0)), trace_color, 2.0)
		var tuned_normalized := clampf((tuned_frequency - frequency_min) / maxf(0.001, frequency_max - frequency_min), 0.0, 1.0)
		var tuned_x := plot_rect.position.x + plot_rect.size.x * tuned_normalized
		draw_line(Vector2(tuned_x, plot_rect.position.y), Vector2(tuned_x, plot_rect.end.y), Color(0.88, 0.72, 0.42, 0.75), 1.5)

var game
var root_column: VBoxContainer
var body: VBoxContainer
var status_label: Label
var text_scale_label: Label
var selected_document_id := ""
var selected_assignment_id := "A-001"
var archive_query := ""
var archive_search_input: LineEdit
var note_source_select: OptionButton
var note_class_select: OptionButton
var report_editor: TextEdit
var note_editor: TextEdit
var recommendation_select: OptionButton
var frequency_spin: SpinBox
var receiver_audio: AudioStreamPlayer
var speech_player: AudioStreamPlayer
var audio_playback: AudioStreamGeneratorPlayback
var audio_enabled := true
var audio_phase := 0.0
var status_message := "LOCAL SIMULATION — no network or microphone access."

func _ready() -> void:
	_setup_receiver_audio()
	game = GameState.new()
	audio_enabled = bool(game.data.get("settings", {}).get("audio_enabled", true))
	if not String(game.load_notice).is_empty():
		status_message = String(game.load_notice)
	_build_shell()
	_refresh()

func _process(_delta: float) -> void:
	_update_receiver_audio()

func _setup_receiver_audio() -> void:
	receiver_audio = AudioStreamPlayer.new()
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = 22050.0
	generator.buffer_length = 0.15
	receiver_audio.stream = generator
	receiver_audio.volume_db = -25.0
	add_child(receiver_audio)
	receiver_audio.play()
	audio_playback = receiver_audio.get_stream_playback() as AudioStreamGeneratorPlayback
	speech_player = AudioStreamPlayer.new()
	speech_player.volume_db = -5.0
	add_child(speech_player)

func _update_receiver_audio() -> void:
	if audio_playback == null or not audio_enabled or game == null:
		return
	if not bool(game.data.get("receiver_power", false)):
		return
	var frames := audio_playback.get_frames_available()
	if frames <= 0:
		return
	var buffer := PackedVector2Array()
	buffer.resize(frames)
	for i in range(frames):
		var noise := randf_range(-1.0, 1.0) * 0.16
		audio_phase += 2.0 * PI * 73.0 / 22050.0
		var hum := sin(audio_phase) * 0.018
		var sample := clampf(noise + hum, -0.2, 0.2)
		buffer[i] = Vector2(sample, sample)
	audio_playback.push_buffer(buffer)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		if game != null:
			game.save_game()

func _build_shell() -> void:
	var background := ColorRect.new()
	background.color = BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	root_column = VBoxContainer.new()
	root_column.add_theme_constant_override("separation", 10)
	margin.add_child(root_column)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	root_column.add_child(header)

	var brand := Label.new()
	brand.text = "DEAD AIR  /  REMOTE MONITORING SITE 04"
	brand.add_theme_font_size_override("font_size", 22)
	brand.add_theme_color_override("font_color", ACCENT)
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(brand)

	var shift := Label.new()
	shift.text = "NRMS  •  SHIFT 01  •  LOCAL RECORDS"
	shift.add_theme_font_size_override("font_size", 13)
	shift.add_theme_color_override("font_color", MUTED)
	header.add_child(shift)

	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 6)
	root_column.add_child(nav)
	for section in SECTIONS:
		var button := Button.new()
		button.text = section.to_upper()
		button.custom_minimum_size = Vector2(118, 42)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_nav_pressed.bind(section))
		nav.add_child(button)

	var line := HSeparator.new()
	root_column.add_child(line)

	var workspace := PanelContainer.new()
	workspace.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workspace.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = PANEL
	panel_style.set_corner_radius_all(8)
	panel_style.content_margin_left = 14
	panel_style.content_margin_right = 14
	panel_style.content_margin_top = 12
	panel_style.content_margin_bottom = 12
	workspace.add_theme_stylebox_override("panel", panel_style)
	root_column.add_child(workspace)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	workspace.add_child(scroll)

	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 10)
	scroll.add_child(body)

	status_label = Label.new()
	status_label.text = status_message
	status_label.add_theme_color_override("font_color", MUTED)
	status_label.add_theme_font_size_override("font_size", 12)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_column.add_child(status_label)

	var settings_row := HBoxContainer.new()
	settings_row.add_theme_constant_override("separation", 6)
	root_column.add_child(settings_row)
	text_scale_label = Label.new()
	text_scale_label.text = "TEXT SIZE"
	text_scale_label.add_theme_color_override("font_color", MUTED)
	settings_row.add_child(text_scale_label)
	_button("A−", _decrease_text_size, settings_row)
	_button("A+", _increase_text_size, settings_row)
	_add_text("AUDIO: LOCAL SYNTH", 11, MUTED, settings_row)
	_add_text("SPEECH SPEED", 11, MUTED, settings_row)
	_button("−", _decrease_speech_rate, settings_row)
	_add_text("%.1fx" % _speech_rate(), 11, ACCENT, settings_row)
	_button("+", _increase_speech_rate, settings_row)

func _refresh() -> void:
	if body == null:
		return
	for child in body.get_children():
		body.remove_child(child)
		child.queue_free()
	var section := String(game.data.get("current_section", "Receiver"))
	match section:
		"Receiver":
			_draw_receiver()
		"Recordings":
			_draw_recordings()
		"Archive":
			_draw_archive()
		"Notebook":
			_draw_notebook()
		"Assignments":
			_draw_assignments()
		"Messages":
			_draw_messages()
		_:
			_draw_receiver()
	status_label.text = status_message

func _text_scale() -> float:
	if game == null:
		return 1.0
	var settings: Dictionary = game.data.get("settings", {})
	return clampf(float(settings.get("text_scale", 1.0)), 0.85, 1.35)

func _decrease_text_size() -> void:
	_change_text_scale(-0.1)

func _increase_text_size() -> void:
	_change_text_scale(0.1)

func _change_text_scale(delta: float) -> void:
	var settings: Dictionary = game.data.get("settings", {})
	settings["text_scale"] = clampf(_text_scale() + delta, 0.85, 1.35)
	game.data["settings"] = settings
	game.save_game()
	for child in root_column.get_children():
		if child is HBoxContainer:
			for control in child.get_children():
				if control is Button:
					control.add_theme_font_size_override("font_size", int(round(14.0 * _text_scale())))
	status_message = "Text size set to %d%%." % int(round(_text_scale() * 100.0))
	_refresh()

func _on_nav_pressed(section: String) -> void:
	game.data["current_section"] = section
	game.save_game()
	_refresh()

func _heading(title: String, subtitle: String = "") -> void:
	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", int(round(21.0 * _text_scale())))
	title_label.add_theme_color_override("font_color", ACCENT)
	body.add_child(title_label)
	if not subtitle.is_empty():
		_add_text(subtitle, 13, MUTED)

func _add_text(value: String, size: int = 15, color: Color = TEXT, target: Container = null) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", int(round(float(size) * _text_scale())))
	label.add_theme_color_override("font_color", color)
	if target == null:
		body.add_child(label)
	else:
		target.add_child(label)
	return label

func _button(label_text: String, callback: Callable, target: Container = null) -> Button:
	var button := Button.new()
	button.text = label_text
	button.custom_minimum_size = Vector2(112, 38)
	button.add_theme_font_size_override("font_size", int(round(14.0 * _text_scale())))
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.pressed.connect(callback)
	if target == null:
		body.add_child(button)
	else:
		target.add_child(button)
	return button

func _row(target: Container = null) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if target == null:
		body.add_child(row)
	else:
		target.add_child(row)
	return row

func _find_event(event_id: String) -> Dictionary:
	for event in Catalog.EVENTS:
		if String(event.get("id", "")) == event_id:
			return event
	return {}

func _find_document(document_id: String) -> Dictionary:
	for document in Catalog.DOCUMENTS:
		if String(document.get("id", "")) == document_id:
			return document
	return {}

func _draw_receiver() -> void:
	_heading("RECEIVER", "Curated offline signal simulation. This is not a live radio or SDR.")
	var control_row := _row()
	var power_text := "POWER OFF" if bool(game.data.get("receiver_power", false)) else "POWER ON"
	_button(power_text, _toggle_receiver, control_row)
	_button("AUDIO ON" if audio_enabled else "AUDIO OFF", _toggle_audio, control_row)

	_add_text("FREQUENCY (MHz)", 12, MUTED, control_row)
	frequency_spin = SpinBox.new()
	var selected_band := String(game.data.get("band", "HF"))
	match selected_band:
		"HF":
			frequency_spin.min_value = 3.0
			frequency_spin.max_value = 30.0
		"VHF":
			frequency_spin.min_value = 30.001
			frequency_spin.max_value = 300.0
		"UHF":
			frequency_spin.min_value = 300.001
			frequency_spin.max_value = 3000.0
		_:
			frequency_spin.min_value = 3.0
			frequency_spin.max_value = 30.0
	frequency_spin.step = 0.001 if selected_band == "HF" else (0.005 if selected_band == "VHF" else 0.025)
	frequency_spin.rounded = false
	frequency_spin.value = float(game.data.get("frequency_mhz", 10.0))
	frequency_spin.custom_minimum_size = Vector2(145, 38)
	control_row.add_child(frequency_spin)
	_button("−STEP", _step_frequency.bind(-1), control_row)
	_button("+STEP", _step_frequency.bind(1), control_row)

	_button("APPLY", _apply_receiver_settings, control_row)
	_button("SEEK NEXT", _seek_next, control_row)
	frequency_spin.value_changed.connect(_on_frequency_changed)

	var band_row := _row()
	_add_text("BAND", 12, MUTED, band_row)
	for band in ["HF", "VHF", "UHF"]:
		_choice_button(band, _select_band.bind(band), selected_band == band, band_row)
	var mode_row := _row()
	_add_text("MODE", 12, MUTED, mode_row)
	var current_mode := String(game.data.get("mode", "AM"))
	for mode in ["AM", "FM", "NFM", "USB", "LSB", "CW"]:
		_choice_button(mode, _select_mode.bind(mode), current_mode == mode, mode_row)

	var live_state := "RX ON" if bool(game.data.get("receiver_power", false)) else "RX OFF — retained events remain available"
	_add_text(live_state, 13, ACCENT if bool(game.data.get("receiver_power", false)) else WARNING)
	_draw_waterfall()
	_draw_tuned_event_matches()

	var selected := _find_event(String(game.data.get("selected_event_id", "SIG-0001")))
	if not selected.is_empty():
		_add_text("SELECTED EVENT  /  " + String(selected.get("id", "")) + "  /  " + String(selected.get("kind", "")), 15, ACCENT)
		_add_text("%.3f MHz  •  %s  •  %s" % [float(selected.get("frequency_mhz", 0.0)), String(selected.get("mode", "")), String(selected.get("time_label", ""))], 14, TEXT)
		_add_text("Time basis: " + String(selected.get("time_basis", "unknown")), 12, MUTED)
		_add_text("Classification: " + String(selected.get("classification", "UNCLASSIFIED")), 13, MUTED)
		if not String(selected.get("identifier", "")).is_empty():
			_add_text("Identifier: " + String(selected.get("identifier", "")) + "    Sequence: " + String(selected.get("sequence", "")), 15, WARNING)
		_add_text("TRANSCRIPT / DECODE", 12, ACCENT)
		_add_text(String(selected.get("transcript", "")), 15, TEXT)
		_add_text("Provenance: " + String(selected.get("provenance", "")), 12, MUTED)
		var action_row := _row()
		var recorded: bool = game.data.get("recorded_event_ids", []).has(String(selected.get("id", "")))
		_button("RECORDED" if recorded else "MANUAL RECORD", _record_selected_event.bind(String(selected.get("id", ""))), action_row)
		_button("OPEN IN RECORDINGS", _open_recordings.bind(String(selected.get("id", ""))), action_row)
		_button("PLAY SIGNAL AUDIO", _play_selected_signal, action_row)
		_button("READ TEXT", _speak_selected_transcript, action_row)
		_button("STOP AUDIO", _stop_audio, action_row)

	_add_text("RETAINED EVENT INDEX", 13, ACCENT)
	for event in Catalog.EVENTS:
		var label := "%s   %.3f MHz %s   %s" % [String(event.get("id", "")), float(event.get("frequency_mhz", 0.0)), String(event.get("mode", "")), String(event.get("kind", ""))]
		_button(label, _select_event.bind(String(event.get("id", ""))))

func _draw_tuned_event_matches() -> void:
	_add_text("TUNED EVENT CHECK", 13, ACCENT)
	if not bool(game.data.get("receiver_power", false)):
		_add_text("Receiver is off. Retained events remain available below and in Recordings.", 12, MUTED)
		return
	var frequency := float(game.data.get("frequency_mhz", 10.0))
	var mode := String(game.data.get("mode", "AM"))
	var match_count := 0
	for event in Catalog.EVENTS:
		var event_frequency := float(event.get("frequency_mhz", 0.0))
		var event_mode := String(event.get("mode", ""))
		if absf(event_frequency - frequency) <= 0.0005 and event_mode == mode:
			match_count += 1
			_button("OPEN MATCH  /  " + String(event.get("id", "")), _select_event.bind(String(event.get("id", ""))))
	if match_count == 0:
		_add_text("No authored event matches this exact frequency/mode. This is not evidence that no transmission exists; retained events are still accessible.", 12, WARNING)
	else:
		_add_text("%d authored event(s) match the current tuning. This is a curated simulation, not a live receiver." % match_count, 12, MUTED)

func _draw_waterfall() -> void:
	var frame := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.018, 0.035, 0.04, 1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	frame.add_theme_stylebox_override("panel", style)
	body.add_child(frame)
	var visual := VBoxContainer.new()
	frame.add_child(visual)
	_add_text("WATERFALL  /  FREQUENCY →     TIME ↓", 11, MUTED, visual)
	_add_text("Tap a visible trace to tune; drag across the display to explore frequencies.", 11, MUTED, visual)
	var plot := WaterfallPlot.new()
	plot.events = Catalog.EVENTS
	var bounds := _band_bounds(String(game.data.get("band", "HF")))
	plot.frequency_min = bounds.x
	plot.frequency_max = bounds.y
	plot.tuned_frequency = float(game.data.get("frequency_mhz", 10.0))
	plot.frequency_selected.connect(_on_waterfall_frequency_selected)
	plot.event_selected.connect(_select_event)
	plot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	visual.add_child(plot)
	_add_text("Axes: frequency in MHz (horizontal); Site 04 displayed event time, 08:00–08:30 (vertical).", 11, MUTED, visual)
	_add_text("Only SIG-0001–0003 are plotted. Prior-cycle and next-shift receptions are excluded because their dates are unknown; their records remain accessible.", 11, WARNING, visual)

func _speech_rate() -> float:
	return clampf(float(game.data.get("settings", {}).get("speech_rate", 1.0)), 0.75, 1.25)

func _change_speech_rate(delta: float) -> void:
	var settings: Dictionary = game.data.get("settings", {})
	settings["speech_rate"] = clampf(_speech_rate() + delta, 0.75, 1.25)
	game.data["settings"] = settings
	game.save_game()
	status_message = "Speech readout speed set to %.1fx." % _speech_rate()
	_refresh()

func _decrease_speech_rate() -> void:
	_change_speech_rate(-0.1)

func _increase_speech_rate() -> void:
	_change_speech_rate(0.1)

func _play_selected_signal() -> void:
	if not audio_enabled:
		status_message = "Audio is muted. Enable AUDIO to play the local signal rendering."
		_refresh()
		return
	var selected := _find_event(String(game.data.get("selected_event_id", "")))
	if selected.is_empty() or speech_player == null:
		return
	var generated: AudioStreamWAV = SignalAudioEngine.build_event_audio(selected, _speech_rate())
	if generated == null:
		status_message = "No playable signal rendering is available for this event."
		_refresh()
		return
	speech_player.stop()
	speech_player.stream = generated
	speech_player.play()
	var mode := String(selected.get("mode", ""))
	var audio_description := "keyed CW tone" if mode == "CW" else "local synthetic monitor audio"
	status_message = "Playing %s for %s. The retained transcript remains authoritative." % [audio_description, String(selected.get("id", ""))]
	_refresh()

func _speak_selected_transcript() -> void:
	if not audio_enabled:
		status_message = "Audio is muted. Enable AUDIO to hear the optional spoken text readout."
		_refresh()
		return
	var selected := _find_event(String(game.data.get("selected_event_id", "")))
	if selected.is_empty() or speech_player == null:
		return
	var generated: AudioStreamWAV = SpeechEngine.synthesize(String(selected.get("transcript", "")), _speech_rate(), 0.94, String(selected.get("voice_profile", "FIELD")) )
	if generated != null:
		speech_player.stop()
		speech_player.stream = generated
		speech_player.play()
		status_message = "Spoken text readout playing for %s. This is an accessibility rendering, not source audio." % String(selected.get("id", ""))
	else:
		status_message = "No text was available for the spoken readout."
	_refresh()

func _stop_audio() -> void:
	if speech_player != null:
		speech_player.stop()
	status_message = "Audio playback stopped."
	_refresh()

func _toggle_audio() -> void:
	audio_enabled = not audio_enabled
	if not audio_enabled and speech_player != null:
		speech_player.stop()
	game.data["settings"]["audio_enabled"] = audio_enabled
	game.save_game()
	status_message = "All local audio enabled." if audio_enabled else "All local audio muted."
	_refresh()

func _toggle_receiver() -> void:
	var next_power := not bool(game.data.get("receiver_power", false))
	game.set_receiver(next_power, float(game.data.get("frequency_mhz", 10.0)), String(game.data.get("mode", "AM")))
	status_message = "Receiver powered on. Retained events are unchanged." if next_power else "Receiver powered off. Archive and retained events remain available."
	game.log_event(status_message)
	_refresh()

func _on_frequency_changed(value: float) -> void:
	game.data["frequency_mhz"] = value
	game.data["band"] = _band_for_frequency(value)
	game.save_game()

func _apply_receiver_settings() -> void:
	var frequency := float(game.data.get("frequency_mhz", 10.0))
	var mode := String(game.data.get("mode", "AM"))
	if frequency_spin != null:
		frequency = frequency_spin.value
	game.data["band"] = _band_for_frequency(frequency)
	game.set_receiver(bool(game.data.get("receiver_power", false)), frequency, mode)
	status_message = "Receiver settings saved: %.3f MHz / %s." % [frequency, mode]
	_refresh()

func _seek_next() -> void:
	if not bool(game.data.get("receiver_power", false)):
		status_message = "SEEK unavailable while RX is off. Power on the receiver first."
		_refresh()
		return
	var selected_band := String(game.data.get("band", "HF"))
	var selected_mode := String(game.data.get("mode", "AM"))
	var current_frequency := float(game.data.get("frequency_mhz", 10.0))
	var current_id := String(game.data.get("selected_event_id", ""))
	var matches: Array = []
	for event in Catalog.EVENTS:
		var event_frequency := float(event.get("frequency_mhz", 0.0))
		if _band_for_frequency(event_frequency) == selected_band and String(event.get("mode", "")) == selected_mode:
			matches.append(event)
	if matches.is_empty():
		status_message = "No authored event is indexed in %s / %s. No new event was created; retained events remain accessible." % [selected_band, selected_mode]
		_refresh()
		return
	var same_frequency: Array = []
	for event in matches:
		if String(event.get("id", "")) != current_id and absf(float(event.get("frequency_mhz", 0.0)) - current_frequency) <= 0.0005:
			same_frequency.append(event)
	var chosen: Dictionary = {}
	if not same_frequency.is_empty():
		chosen = same_frequency[0]
	else:
		var next_frequency := INF
		for event in matches:
			var event_frequency := float(event.get("frequency_mhz", 0.0))
			if event_frequency > current_frequency + 0.0005 and event_frequency < next_frequency:
				next_frequency = event_frequency
				chosen = event
		if chosen.is_empty():
			var first_frequency := INF
			for event in matches:
				var event_frequency := float(event.get("frequency_mhz", 0.0))
				if event_frequency < first_frequency:
					first_frequency = event_frequency
					chosen = event
	if chosen.is_empty() or String(chosen.get("id", "")) == current_id:
		status_message = "No further authored event is indexed in %s / %s. The receiver has not invented a stop." % [selected_band, selected_mode]
		_refresh()
		return
	game.select_event(String(chosen.get("id", "")))
	game.set_receiver(true, float(chosen.get("frequency_mhz", 10.0)), selected_mode)
	status_message = "SEEK selected %s at %.3f MHz / %s within %s." % [String(chosen.get("id", "")), float(chosen.get("frequency_mhz", 0.0)), selected_mode, selected_band]
	_refresh()

func _band_bounds(band: String) -> Vector2:
	match band:
		"VHF":
			return Vector2(30.001, 300.0)
		"UHF":
			return Vector2(300.001, 3000.0)
		_:
			return Vector2(3.0, 30.0)

func _on_waterfall_frequency_selected(frequency: float) -> void:
	var bounds := _band_bounds(String(game.data.get("band", "HF")))
	var tuned := clampf(frequency, bounds.x, bounds.y)
	game.data["frequency_mhz"] = tuned
	game.save_game()
	if frequency_spin != null:
		frequency_spin.value = tuned
	status_message = "Waterfall tuning set to %.3f MHz. No event was inferred at this frequency." % tuned
	if status_label != null:
		status_label.text = status_message

func _step_frequency(direction: int) -> void:
	var band := String(game.data.get("band", "HF"))
	var bounds := _band_bounds(band)
	var step := 0.001 if band == "HF" else (0.005 if band == "VHF" else 0.025)
	var frequency := clampf(float(game.data.get("frequency_mhz", bounds.x)) + step * float(direction), bounds.x, bounds.y)
	game.set_receiver(bool(game.data.get("receiver_power", false)), frequency, String(game.data.get("mode", "AM")))
	status_message = "Fine tune: %.3f MHz." % frequency
	_refresh()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if String(game.data.get("current_section", "Receiver")) != "Receiver":
		return
	if event.keycode == KEY_LEFT:
		_step_frequency(-1)
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_RIGHT:
		_step_frequency(1)
		get_viewport().set_input_as_handled()

func _band_for_frequency(frequency: float) -> String:
	if frequency <= 30.0:
		return "HF"
	if frequency <= 300.0:
		return "VHF"
	return "UHF"

func _choice_button(label_text: String, callback: Callable, selected: bool, target: Container) -> Button:
	var button := Button.new()
	button.text = label_text
	button.toggle_mode = true
	button.button_pressed = selected
	button.custom_minimum_size = Vector2(72, 36)
	button.add_theme_font_size_override("font_size", int(round(13.0 * _text_scale())))
	if selected:
		button.add_theme_color_override("font_color", ACCENT)
	button.pressed.connect(callback)
	target.add_child(button)
	return button

func _select_band(band: String) -> void:
	var defaults := {"HF":10.000, "VHF":145.500, "UHF":446.000}
	if not defaults.has(band):
		return
	game.data["band"] = band
	game.data["frequency_mhz"] = float(defaults[band])
	game.save_game()
	status_message = "%s band selected. Frequency moved to its local default; no signal is implied." % band
	_refresh()

func _select_mode(mode: String) -> void:
	if not ["AM", "FM", "NFM", "USB", "LSB", "CW"].has(mode):
		return
	game.data["mode"] = mode
	game.save_game()
	status_message = "%s mode selected." % mode
	_refresh()

func _select_event(event_id: String) -> void:
	game.select_event(event_id)
	var event := _find_event(event_id)
	if not event.is_empty():
		game.set_receiver(bool(game.data.get("receiver_power", false)), float(event.get("frequency_mhz", 10.0)), String(event.get("mode", "AM")))
		status_message = "Tuned to retained event " + event_id + "."
	_refresh()

func _record_selected_event(event_id: String) -> void:
	game.record_event(event_id)
	status_message = event_id + " manually recorded. Automatic retention and manual recording are separate."
	_refresh()

func _open_recordings(event_id: String) -> void:
	game.select_event(event_id)
	game.data["current_section"] = "Recordings"
	game.save_game()
	_refresh()

func _draw_recordings() -> void:
	_heading("RECORDINGS", "Retained reception events are available even when the receiver is off.")
	for event in Catalog.EVENTS:
		var event_id := String(event.get("id", ""))
		var manually_recorded: bool = game.data.get("recorded_event_ids", []).has(event_id)
		var prefix := "MANUAL RECORD" if manually_recorded else "AUTO-RETAINED"
		var row := _row()
		_button(event_id + "  /  " + prefix, _select_event_from_recordings.bind(event_id), row)
		_add_text("%.3f MHz %s — %s" % [float(event.get("frequency_mhz", 0.0)), String(event.get("mode", "")), String(event.get("time_label", ""))], 13, MUTED, row)
		if String(game.data.get("selected_event_id", "")) == event_id:
			_add_text(String(event.get("transcript", "")), 15, TEXT)
			_button("PLAY SIGNAL AUDIO", _play_selected_signal)
			_button("READ TEXT", _speak_selected_transcript)
			_button("STOP AUDIO", _stop_audio)
			_add_text("Time basis: " + String(event.get("time_basis", "")), 12, MUTED)
			_add_text("Provenance: " + String(event.get("provenance", "")), 12, MUTED)

func _select_event_from_recordings(event_id: String) -> void:
	game.select_event(event_id)
	status_message = "Selected " + event_id + ". Original event metadata remains unchanged."
	_refresh()

func _draw_archive() -> void:
	_heading("ARCHIVE", "Searchable institutional records. A missing result describes the index searched—not reality.")
	var search_row := _row()
	archive_search_input = LineEdit.new()
	archive_search_input.placeholder_text = "Search ID, title, source, or text"
	archive_search_input.text = archive_query
	archive_search_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_row.add_child(archive_search_input)
	_button("SEARCH", _run_archive_search, search_row)
	_button("CLEAR", _clear_archive_search, search_row)
	var matches: Array = []
	var query := archive_query.to_lower()
	for document in Catalog.DOCUMENTS:
		if String(document.get("status", "")) == "LOCKED UNTIL REPORT" and game.data.get("reports", []).is_empty():
			continue
		var searchable := (String(document.get("id", "")) + " " + String(document.get("title", "")) + " " + String(document.get("source", "")) + " " + String(document.get("body", ""))).to_lower()
		if query.is_empty() or searchable.contains(query):
			matches.append(document)
	if matches.is_empty():
		_add_text("No matching record found in this index. This result describes the collection searched only.", 12, WARNING)
	else:
		_add_text("%d record(s) in this collection match the current query." % matches.size(), 12, MUTED)
	for document in matches:
		var doc_id := String(document.get("id", ""))
		_button(doc_id + "  —  " + String(document.get("title", "")), _select_document.bind(doc_id))
	if not selected_document_id.is_empty():
		var document := _find_document(selected_document_id)
		if not document.is_empty():
			_add_text("DOCUMENT DETAIL  /  " + String(document.get("id", "")), 16, ACCENT)
			_add_text(String(document.get("title", "")), 20, TEXT)
			_add_text("Source: " + String(document.get("source", "")), 12, MUTED)
			_add_text("Claimed event time: " + String(document.get("claimed_event_time", "")), 12, MUTED)
			_add_text("Clock basis: " + String(document.get("clock_basis", "")), 12, WARNING)
			var document_status := String(document.get("status", ""))
			if String(document.get("id", "")) == "M-10B" and not game.data.get("reports", []).is_empty():
				document_status = "AVAILABLE AFTER REPORT"
			_add_text("Status: " + document_status + "  •  Version " + str(document.get("version", 1)), 12, MUTED)
			_add_text(String(document.get("body", "")), 15, TEXT)
			var related_ids: Array = document.get("related_ids", [])
			_add_text("Related records: " + str(related_ids), 12, MUTED)
			var related_row: HBoxContainer = null
			var related_button_count := 0
			for related_id_value in related_ids:
				var related_id := String(related_id_value)
				if _find_document(related_id).is_empty() and _find_event(related_id).is_empty():
					continue
				if related_row == null or related_button_count % 3 == 0:
					related_row = _row()
				_button("OPEN " + related_id, _open_related_record.bind(related_id), related_row)
				related_button_count += 1
			_add_text("Related-record links are retrieval aids, not proof of a common source or origin.", 11, MUTED)
			_add_text("Original text is retained as authored. No timestamp normalization is applied.", 12, WARNING)

func _run_archive_search() -> void:
	archive_query = archive_search_input.text.strip_edges() if archive_search_input != null else ""
	selected_document_id = ""
	_refresh()

func _clear_archive_search() -> void:
	archive_query = ""
	selected_document_id = ""
	_refresh()

func _open_related_record(record_id: String) -> void:
	if not _find_event(record_id).is_empty():
		game.select_event(record_id)
		game.data["current_section"] = "Receiver"
		status_message = "Opened related signal " + record_id + ". The index link does not establish a common source."
	elif not _find_document(record_id).is_empty():
		selected_document_id = record_id
		archive_query = ""
		game.mark_document_read(record_id)
		game.data["current_section"] = "Archive"
		status_message = "Opened related record " + record_id + ". The index link does not establish a common origin."
	else:
		status_message = "Related record " + record_id + " is not available in the local catalog."
		_refresh()
		return
	game.save_game()
	_refresh()

func _select_document(document_id: String) -> void:
	selected_document_id = document_id
	game.mark_document_read(document_id)
	status_message = "Opened " + document_id + ". Original record text is unchanged."
	_refresh()

func _open_required_document(document_id: String) -> void:
	archive_query = ""
	selected_document_id = document_id
	game.mark_document_read(document_id)
	game.data["current_section"] = "Archive"
	game.save_game()
	status_message = "Opened required record " + document_id + " from the evidence checklist."
	_refresh()

func _has_required_documents() -> bool:
	var required_ids := ["M-02", "M-05", "M-07", "M-08", "M-09"]
	for document_id in required_ids:
		if not game.data.get("documents_read", []).has(document_id):
			return false
	return true

func _draw_notebook() -> void:
	_heading("NOTEBOOK", "Private working notes. Classification is your assessment, not a system verdict.")
	note_editor = TextEdit.new()
	note_editor.placeholder_text = "Write a note. Link a source if useful."
	note_editor.text = String(game.data.get("note_draft", ""))
	note_editor.custom_minimum_size = Vector2(0, 100)
	note_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	note_editor.text_changed.connect(_on_note_draft_changed)
	body.add_child(note_editor)
	var classification_row := _row()
	_add_text("NOTE CLASSIFICATION", 12, MUTED, classification_row)
	note_class_select = OptionButton.new()
	for classification in ["UNCLASSIFIED", "OBSERVED FACT", "WORKING HYPOTHESIS", "OPEN QUESTION"]:
		note_class_select.add_item(classification)
	var saved_classification := String(game.data.get("note_draft_classification", "UNCLASSIFIED"))
	for class_index in range(note_class_select.item_count):
		if note_class_select.get_item_text(class_index) == saved_classification:
			note_class_select.select(class_index)
	note_class_select.item_selected.connect(_on_note_classification_selected)
	note_class_select.custom_minimum_size = Vector2(220, 38)
	classification_row.add_child(note_class_select)
	var source_row := _row()
	_add_text("SOURCE LINK", 12, MUTED, source_row)
	note_source_select = OptionButton.new()
	note_source_select.add_item("No source link")
	for item in ["SIG-0004", "SIG-0005", "M-02", "M-05", "M-06A", "M-07", "M-08", "M-09"]:
		note_source_select.add_item(item)
	note_source_select.custom_minimum_size = Vector2(170, 38)
	source_row.add_child(note_source_select)
	_button("SAVE NOTE", _save_note_from_ui, source_row)
	_add_text("SAVED NOTES", 14, ACCENT)
	if game.data.get("notes", []).is_empty():
		_add_text("No saved notes yet.", 13, MUTED)
	for note in game.data.get("notes", []):
		var note_id := String(note.get("id", ""))
		var source_id := String(note.get("source_id", ""))
		_add_text(note_id + "  /  " + String(note.get("classification", "UNCLASSIFIED")) + (("  /  SOURCE: " + source_id) if not source_id.is_empty() else "  /  NO SOURCE LINK"), 12, MUTED)
		_add_text(String(note.get("text", "")), 15, TEXT)
		if not source_id.is_empty():
			var source_title := _source_display_title(source_id)
			_add_text("Evidence reference: " + source_title, 12, MUTED)
			_button("OPEN SOURCE " + source_id, _open_note_source.bind(source_id))
		_button("DELETE " + note_id, _delete_note.bind(note_id))

func _save_note_from_ui() -> void:
	var source_id := ""
	if note_source_select != null and note_source_select.selected > 0:
		source_id = note_source_select.get_item_text(note_source_select.selected)
	if note_editor == null:
		return
	game.add_note(note_editor.text, source_id, String(game.data.get("note_draft_classification", "UNCLASSIFIED")))
	game.data["note_draft"] = ""
	game.data["note_draft_classification"] = "UNCLASSIFIED"
	game.save_game()
	status_message = "Notebook entry saved."
	_refresh()

func _on_note_classification_selected(index: int) -> void:
	if note_class_select == null:
		return
	game.data["note_draft_classification"] = note_class_select.get_item_text(index)
	game.save_game()

func _on_note_draft_changed() -> void:
	if note_editor != null:
		game.data["note_draft"] = note_editor.text
		game.save_game()

func _delete_note(note_id: String) -> void:
	var retained: Array = []
	for note in game.data.get("notes", []):
		if String(note.get("id", "")) != note_id:
			retained.append(note)
	game.data["notes"] = retained
	game.save_game()
	status_message = "Deleted " + note_id + ". Other notes are unchanged."
	_refresh()

func _source_display_title(source_id: String) -> String:
	var event := _find_event(source_id)
	if not event.is_empty():
		return String(event.get("time_label", "")) + " / " + String(event.get("frequency_mhz", "")) + " MHz / " + String(event.get("mode", "")) + " reception"
	var document := _find_document(source_id)
	if not document.is_empty():
		return String(document.get("title", source_id))
	return "Source unavailable in current catalog"

func _open_note_source(source_id: String) -> void:
	if source_id.begins_with("SIG-"):
		game.select_event(source_id)
		game.data["current_section"] = "Receiver"
		status_message = "Opened notebook source " + source_id + ". The saved note remains an interpretation, not a verified fact."
	elif not _find_document(source_id).is_empty():
		selected_document_id = source_id
		archive_query = ""
		game.mark_document_read(source_id)
		game.data["current_section"] = "Archive"
		status_message = "Opened notebook source " + source_id + ". The saved note remains unchanged."
	else:
		status_message = "Notebook source " + source_id + " is not available in the local catalog."
		_refresh()
		return
	game.save_game()
	_refresh()

func _draw_assignments() -> void:
	_heading("ASSIGNMENTS", "No deadlines. Administrative completion does not resolve the case.")
	for assignment in Catalog.ASSIGNMENTS:
		var assignment_id := String(assignment.get("id", ""))
		var current_status := String(game.data.get("assignments", {}).get(assignment_id, "OPEN"))
		_button(assignment_id + "  /  " + String(assignment.get("title", "")) + "  [" + current_status + "]", _select_assignment.bind(assignment_id))
	var assignment := _find_assignment(selected_assignment_id)
	if assignment.is_empty():
		return
	_add_text("SELECTED WORK ORDER  /  " + selected_assignment_id, 16, ACCENT)
	_add_text(String(assignment.get("title", "")), 19, TEXT)
	_add_text(String(assignment.get("description", "")), 15, TEXT)
	_draw_assignment_checklist(selected_assignment_id)
	var action_row := _row()
	var selected_status := String(game.data.get("assignments", {}).get(selected_assignment_id, "OPEN"))
	var progress_button := _button("MARK IN PROGRESS", _mark_selected_assignment_in_progress, action_row)
	progress_button.disabled = selected_status == "COMPLETED" or selected_status == "CLOSED"
	if selected_assignment_id == "A-003":
		var inspected_events: Array = game.data.get("inspected_event_ids", [])
		if inspected_events.has("SIG-0004") and inspected_events.has("SIG-0005"):
			_button("MARK COMPARISON REVIEWED", _complete_comparison_assignment, action_row)
		else:
			_add_text("Inspect both retained NR-041 receptions before marking this comparison reviewed.", 12, MUTED)
	if selected_assignment_id == "A-005":
		var communications_documents: Array = game.data.get("documents_read", [])
		if selected_status == "COMPLETED":
			_add_text("COMPARISON REVIEWED. Shared printed times do not establish a common source.", 12, ACCENT)
		elif communications_documents.has("M-08") and communications_documents.has("M-09"):
			_add_text("COMPARISON REVIEW  /  SOURCE TEXT SUMMARY", 14, ACCENT)
			_add_text("M-08 — 18:17 activity entry; 18:19 routing activity; 18:23 further activity.", 13, TEXT)
			_add_text("M-09 — 18:19 internal relay receipt; 18:21 route-continuation entry; 18:23 destination acknowledgement.", 13, TEXT)
			_add_text("Shared printed times: 18:19 and 18:23. M-09 also lists 18:21.", 12, MUTED)
			_add_text("Origin and clock basis remain unstated or incomplete. These similarities do not establish an independent original or common source.", 12, WARNING)
			_button("MARK COMMUNICATIONS COMPARISON REVIEWED", _complete_communications_comparison, action_row)
		else:
			_add_text("Open M-08 and M-09, then explicitly review their timestamps and routing details.", 12, MUTED)
	if selected_assignment_id == "A-006":
		_add_text("REQUIRED RECORD REVIEW", 14, ACCENT)
		for required_id in ["M-02", "M-05", "M-07", "M-08", "M-09"]:
			if game.data.get("documents_read", []).has(required_id):
				_add_text("READ  /  " + required_id, 12, ACCENT)
			else:
				_button("OPEN REQUIRED RECORD  /  " + required_id, _open_required_document.bind(required_id))
		if not _has_required_documents():
			_add_text("Review each required record before submitting. All records remain available in the archive; no live reception is required.", 12, WARNING)
		_add_text("REPORT DRAFT", 14, ACCENT)
		report_editor = TextEdit.new()
		report_editor.text = String(game.data.get("report_draft", ""))
		report_editor.placeholder_text = "State observations and limits of the evidence."
		report_editor.custom_minimum_size = Vector2(0, 130)
		report_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		report_editor.text_changed.connect(_on_report_draft_changed)
		body.add_child(report_editor)
		_add_text("RECOMMENDED ACTION", 12, MUTED)
		recommendation_select = OptionButton.new()
		for option in [
			"Retain records and request clock/source documentation.",
			"Request independent technical review.",
			"Close this report with source attribution unresolved."
		]:
			recommendation_select.add_item(option)
		var selected_rec := String(game.data.get("report_recommendation", "Retain records and request clock/source documentation."))
		for i in range(recommendation_select.item_count):
			if recommendation_select.get_item_text(i) == selected_rec:
				recommendation_select.select(i)
		body.add_child(recommendation_select)
		_add_text("REPORT SOURCES", 14, ACCENT)
		_add_text("Select the records you are citing. Similar identifiers do not establish a common source.", 12, MUTED)
		var selected_sources: Array = game.data.get("report_source_ids", REPORT_SOURCE_OPTIONS.duplicate())
		game.data["report_source_ids"] = selected_sources
		var source_row: HBoxContainer = null
		for source_index in range(REPORT_SOURCE_OPTIONS.size()):
			if source_index % 3 == 0:
				source_row = _row()
			var source_id: String = REPORT_SOURCE_OPTIONS[source_index]
			var source_check := CheckBox.new()
			source_check.text = source_id
			source_check.custom_minimum_size = Vector2(110, 38)
			source_check.button_pressed = selected_sources.has(source_id)
			source_check.toggled.connect(_on_report_source_toggled.bind(source_id))
			source_row.add_child(source_check)
		var submit_label := "SUBMIT REPORT" if game.data.get("reports", []).is_empty() else "SUBMIT ADDENDUM"
		var submit_button := _button(submit_label, _submit_report)
		submit_button.disabled = not _has_required_documents()
		_add_text("Submissions are permanent. Later submissions append a separate report; the assignment remains closed and the case thread unresolved.", 12, WARNING)
	if not game.data.get("reports", []).is_empty():
		_add_text("SUBMITTED REPORTS", 14, ACCENT)
		for report in game.data.get("reports", []):
			_add_text(String(report.get("id", "")) + " — " + String(report.get("status", "")) + " / Case: " + String(report.get("case_status", "")), 13, MUTED)
			_add_text(String(report.get("body", "")), 14, TEXT)
			_add_text("Recommended action: " + String(report.get("recommendation", "")), 12, MUTED)
			_add_text("Source links: " + str(report.get("source_ids", [])), 12, MUTED)

func _draw_assignment_checklist(assignment_id: String) -> void:
	_add_text("PROGRESS CHECKLIST", 13, ACCENT)
	var inspected: Array = game.data.get("inspected_event_ids", [])
	var documents: Array = game.data.get("documents_read", [])
	var assignments: Dictionary = game.data.get("assignments", {})
	match assignment_id:
		"A-001":
			_checklist_item("Receiver powered on", bool(game.data.get("receiver_power", false)))
			_checklist_item("Routine reference SIG-0001 inspected", inspected.has("SIG-0001"))
		"A-002":
			_checklist_item("An NR-041 reception inspected", inspected.has("SIG-0004") or inspected.has("SIG-0005"))
			_checklist_item("Registry record M-02 opened", documents.has("M-02"))
		"A-003":
			_checklist_item("Prior-cycle reception SIG-0004 inspected", inspected.has("SIG-0004"))
			_checklist_item("Next-shift reception SIG-0005 inspected", inspected.has("SIG-0005"))
			_checklist_item("Comparison explicitly reviewed", String(assignments.get("A-003", "OPEN")) == "COMPLETED")
		"A-004":
			_checklist_item("Incident file cover M-06A opened", documents.has("M-06A"))
			_checklist_item("Operations summary M-07 opened", documents.has("M-07"))
			_checklist_item("Technical appendix M-08 opened", documents.has("M-08"))
		"A-005":
			_checklist_item("Technical appendix M-08 opened", documents.has("M-08"))
			_checklist_item("Communications Record 04-C / M-09 opened", documents.has("M-09"))
			_checklist_item("Timestamp and routing comparison reviewed", String(assignments.get("A-005", "OPEN")) == "COMPLETED")
		"A-006":
			for required_id in ["M-02", "M-05", "M-07", "M-08", "M-09"]:
				_checklist_item(required_id + " opened", documents.has(required_id))
			_checklist_item("Chronology review report submitted", not game.data.get("reports", []).is_empty())

func _checklist_item(label: String, complete: bool) -> void:
	_add_text(("DONE  /  " if complete else "OPEN  /  ") + label, 12, ACCENT if complete else MUTED)

func _find_assignment(assignment_id: String) -> Dictionary:
	for assignment in Catalog.ASSIGNMENTS:
		if String(assignment.get("id", "")) == assignment_id:
			return assignment
	return {}

func _mark_selected_assignment_in_progress() -> void:
	var current_status := String(game.data["assignments"].get(selected_assignment_id, "OPEN"))
	if current_status == "COMPLETED" or current_status == "CLOSED":
		status_message = selected_assignment_id + " is already closed to further progress changes."
		_refresh()
		return
	game.data["assignments"][selected_assignment_id] = "IN PROGRESS"
	game.save_game()
	status_message = selected_assignment_id + " marked in progress."
	_refresh()

func _complete_communications_comparison() -> void:
	if not game.complete_communications_comparison():
		status_message = "Comparison remains open until both M-08 and M-09 have been opened."
	else:
		status_message = "A-005 comparison recorded. Similar timestamps and routing entries do not establish an independent original or common source."
	game.save_game()
	_refresh()

func _complete_comparison_assignment() -> void:
	var inspected_events: Array = game.data.get("inspected_event_ids", [])
	if not inspected_events.has("SIG-0004") or not inspected_events.has("SIG-0005"):
		status_message = "Comparison remains open until both retained receptions have been inspected."
		_refresh()
		return
	game.data["assignments"]["A-003"] = "COMPLETED"
	game.save_game()
	status_message = "A-003 comparison marked reviewed. Matching identifiers do not establish a common source."
	_refresh()

func _select_assignment(assignment_id: String) -> void:
	selected_assignment_id = assignment_id
	status_message = "Opened work order " + assignment_id + "."
	_refresh()

func _on_report_draft_changed() -> void:
	if report_editor != null:
		game.data["report_draft"] = report_editor.text
		game.save_game()

func _on_report_source_toggled(checked: bool, source_id: String) -> void:
	var selected_sources: Array = game.data.get("report_source_ids", [])
	if checked:
		if not selected_sources.has(source_id):
			selected_sources.append(source_id)
	else:
		selected_sources.erase(source_id)
	game.data["report_source_ids"] = selected_sources
	game.save_game()
	status_message = "Report source links saved (%d selected)." % selected_sources.size()
	if status_label != null:
		status_label.text = status_message

func _submit_report() -> void:
	if not _has_required_documents():
		status_message = "Report not submitted: review the required archive records first."
		_refresh()
		return
	var report_body := String(game.data.get("report_draft", "")).strip_edges()
	if report_body.is_empty():
		status_message = "Report not submitted: enter observations first."
		_refresh()
		return
	var recommendation := String(game.data.get("report_recommendation", "Retain records and request clock/source documentation."))
	if recommendation_select != null and recommendation_select.selected >= 0:
		recommendation = recommendation_select.get_item_text(recommendation_select.selected)
	var source_ids: Array = game.data.get("report_source_ids", [])
	if source_ids.is_empty():
		status_message = "Report not submitted: select at least one source record."
		_refresh()
		return
	game.data["report_recommendation"] = recommendation
	var report: Dictionary = game.submit_report(report_body, recommendation, source_ids)
	game.data["report_draft"] = ""
	game.data["current_section"] = "Messages"
	game.save_game()
	status_message = String(report.get("id", "REPORT")) + " submitted. Mara's review is now available; source remains unresolved."
	_refresh()

func _draw_messages() -> void:
	_heading("MESSAGES", "Operational correspondence and review notices.")
	for message in Catalog.MESSAGES:
		_add_text(String(message.get("sender", "")) + "  /  " + String(message.get("subject", "")), 16, ACCENT)
		var unread: bool = not game.data.get("messages_seen", []).has(String(message.get("id", "")))
		_add_text("UNREAD" if unread else "READ", 11, WARNING if unread else MUTED)
		_add_text(String(message.get("body", "")), 15, TEXT)
		_button("MARK READ", _mark_message_read.bind(String(message.get("id", ""))))
	if not game.data.get("reports", []).is_empty():
		_add_text("SUBMITTED REPORT HISTORY  /  READ-ONLY", 16, ACCENT)
		for report in game.data.get("reports", []):
			_add_text(String(report.get("id", "REPORT-UNKNOWN")) + "  /  " + String(report.get("kind", "INITIAL")) + "  /  " + String(report.get("status", "SUBMITTED")), 14, ACCENT)
			_add_text(String(report.get("body", "")), 15, TEXT)
			_add_text("Recommended action: " + String(report.get("recommendation", "")), 13, TEXT)
			var report_sources: Array = report.get("source_ids", [])
			_add_text("Cited source IDs: " + ", ".join(PackedStringArray(report_sources)), 12, MUTED)
			var source_row: HBoxContainer = null
			for source_index in range(report_sources.size()):
				if source_index % 3 == 0:
					source_row = _row()
				var source_id := String(report_sources[source_index])
				_button("OPEN " + source_id, _open_report_source.bind(source_id), source_row)
			_add_text("Case status: " + String(report.get("case_status", "UNRESOLVED")) + "  •  Version " + str(report.get("version", 1)), 12, WARNING)
		_add_text("MARA VENN  /  REGIONAL OPERATIONS REVIEW", 16, ACCENT)
		var response := _find_document("M-10B")
		_add_text(String(response.get("body", "")), 15, TEXT)
		_add_text("Administrative status: accepted for filing. Case status: unresolved.", 12, WARNING)
		_button("OPEN REPORT / ADDENDUM FORM", _open_report_assignment)
		_add_text("SHIFT CLOSED — RECORDS RETAINED — SOURCE UNRESOLVED", 17, ACCENT)

func _open_report_assignment() -> void:
	selected_assignment_id = "A-006"
	game.data["current_section"] = "Assignments"
	game.save_game()
	_refresh()

func _open_report_source(source_id: String) -> void:
	if source_id.begins_with("SIG-"):
		game.select_event(source_id)
		game.data["current_section"] = "Receiver"
	elif not _find_document(source_id).is_empty():
		selected_document_id = source_id
		archive_query = ""
		game.mark_document_read(source_id)
		game.data["current_section"] = "Archive"
	else:
		status_message = "Cited source " + source_id + " is not available in the local catalog."
		_refresh()
		return
	game.save_game()
	status_message = "Opened cited source " + source_id + ". Original report remains unchanged."
	_refresh()

func _mark_message_read(message_id: String) -> void:
	game.mark_message_seen(message_id)
	status_message = message_id + " marked read."
	_refresh()
