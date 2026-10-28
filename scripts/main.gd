extends Control

const Catalog = preload("res://scripts/content_catalog.gd")
const GameState = preload("res://scripts/game_state.gd")

const SECTIONS = ["Receiver", "Recordings", "Archive", "Notebook", "Assignments", "Messages"]
const BG = Color(0.035, 0.055, 0.065, 1)
const PANEL = Color(0.065, 0.095, 0.105, 1)
const PANEL_ALT = Color(0.085, 0.125, 0.135, 1)
const TEXT = Color(0.88, 0.92, 0.89, 1)
const MUTED = Color(0.57, 0.68, 0.67, 1)
const ACCENT = Color(0.45, 0.79, 0.65, 1)
const WARNING = Color(0.91, 0.72, 0.43, 1)

var game: RefCounted
var root_column: VBoxContainer
var body: VBoxContainer
var status_label: Label
var selected_document_id := ""
var selected_assignment_id := "A-001"
var archive_query := ""
var report_editor: TextEdit
var note_editor: TextEdit
var recommendation_select: OptionButton
var frequency_spin: SpinBox
var mode_select: OptionButton
var status_message := "LOCAL SIMULATION — no network or microphone access."

func _ready() -> void:
	game = GameState.new()
	_build_shell()
	_refresh()

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

func _on_nav_pressed(section: String) -> void:
	game.data["current_section"] = section
	game.save_game()
	_refresh()

func _heading(title: String, subtitle: String = "") -> void:
	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 21)
	title_label.add_theme_color_override("font_color", ACCENT)
	body.add_child(title_label)
	if not subtitle.is_empty():
		_add_text(subtitle, 13, MUTED)

func _add_text(value: String, size: int = 15, color: Color = TEXT, target: Container = null) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", size)
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

	_add_text("FREQUENCY (MHz)", 12, MUTED, control_row)
	frequency_spin = SpinBox.new()
	frequency_spin.min_value = 0.1
	frequency_spin.max_value = 30000.0
	frequency_spin.step = 0.001
	frequency_spin.rounded = false
	frequency_spin.value = float(game.data.get("frequency_mhz", 10.0))
	frequency_spin.custom_minimum_size = Vector2(145, 38)
	control_row.add_child(frequency_spin)

	mode_select = OptionButton.new()
	for mode in ["AM", "FM", "NFM", "USB", "LSB", "CW"]:
		mode_select.add_item(mode)
	var current_mode := String(game.data.get("mode", "AM"))
	for i in range(mode_select.item_count):
		if mode_select.get_item_text(i) == current_mode:
			mode_select.select(i)
	mode_select.custom_minimum_size = Vector2(100, 38)
	control_row.add_child(mode_select)
	_button("APPLY", _apply_receiver_settings, control_row)
	_button("SEEK NEXT", _seek_next, control_row)
	frequency_spin.value_changed.connect(_on_frequency_changed)
	mode_select.item_selected.connect(_on_mode_changed)

	var live_state := "RX ON" if bool(game.data.get("receiver_power", false)) else "RX OFF — retained events remain available"
	_add_text(live_state, 13, ACCENT if bool(game.data.get("receiver_power", false)) else WARNING)
	_draw_waterfall()

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
		var recorded := game.data.get("recorded_event_ids", []).has(String(selected.get("id", "")))
		_button("RECORDED" if recorded else "MANUAL RECORD", _record_selected_event.bind(String(selected.get("id", ""))), action_row)
		_button("OPEN IN RECORDINGS", _open_recordings.bind(String(selected.get("id", ""))), action_row)

	_add_text("RETAINED EVENT INDEX", 13, ACCENT)
	for event in Catalog.EVENTS:
		var label := "%s   %.3f MHz %s   %s" % [String(event.get("id", "")), float(event.get("frequency_mhz", 0.0)), String(event.get("mode", "")), String(event.get("kind", ""))]
		_button(label, _select_event.bind(String(event.get("id", ""))))

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
	var bands := ["················································", "····· ░░ ·················· ░ ··················", "················ ░░░ ···························", "·································· ░░ ··········", "·········· ░ ···································"]
	for i in range(bands.size()):
		_add_text(bands[i], 14, ACCENT if i == 2 else Color(0.32, 0.55, 0.48, 1), visual)
	_add_text("Illustrative display only. No live RF, hidden imagery, or random corruption.", 11, MUTED, visual)

func _toggle_receiver() -> void:
	var next_power := not bool(game.data.get("receiver_power", false))
	game.set_receiver(next_power, float(game.data.get("frequency_mhz", 10.0)), String(game.data.get("mode", "AM")))
	status_message = "Receiver powered on. Retained events are unchanged." if next_power else "Receiver powered off. Archive and retained events remain available."
	game.log_event(status_message)
	_refresh()

func _on_frequency_changed(value: float) -> void:
	game.data["frequency_mhz"] = value
	game.save_game()

func _on_mode_changed(index: int) -> void:
	if mode_select != null:
		game.data["mode"] = mode_select.get_item_text(index)
		game.save_game()

func _apply_receiver_settings() -> void:
	var frequency := float(game.data.get("frequency_mhz", 10.0))
	var mode := String(game.data.get("mode", "AM"))
	if frequency_spin != null:
		frequency = frequency_spin.value
	if mode_select != null:
		mode = mode_select.get_item_text(mode_select.selected)
	game.set_receiver(bool(game.data.get("receiver_power", false)), frequency, mode)
	status_message = "Receiver settings saved: %.3f MHz / %s." % [frequency, mode]
	_refresh()

func _seek_next() -> void:
	if not bool(game.data.get("receiver_power", false)):
		status_message = "SEEK unavailable while RX is off. Power on the receiver first."
		_refresh()
		return
	var current_id := String(game.data.get("selected_event_id", "SIG-0001"))
	var current_index := 0
	for i in range(Catalog.EVENTS.size()):
		if String(Catalog.EVENTS[i].get("id", "")) == current_id:
			current_index = i
			break
	var next_index := (current_index + 1) % Catalog.EVENTS.size()
	var event: Dictionary = Catalog.EVENTS[next_index]
	game.select_event(String(event.get("id", "")))
	game.set_receiver(true, float(event.get("frequency_mhz", 10.0)), String(event.get("mode", "AM")))
	status_message = "SEEK selected authored event " + String(event.get("id", "")) + ". No source inference is made."
	_refresh()

func _select_event(event_id: String) -> void:
	game.select_event(event_id)
	var event := _find_event(event_id)
	if not event.is_empty():
		status_message = "Opened retained event " + event_id + "."
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
			_add_text("Time basis: " + String(event.get("time_basis", "")), 12, MUTED)
			_add_text("Provenance: " + String(event.get("provenance", "")), 12, MUTED)

func _select_event_from_recordings(event_id: String) -> void:
	game.select_event(event_id)
	status_message = "Selected " + event_id + ". Original event metadata remains unchanged."
	_refresh()

func _draw_archive() -> void:
	_heading("ARCHIVE", "Searchable institutional records. A missing result describes the index searched—not reality.")
	var search_row := _row()
	var search := LineEdit.new()
	search.placeholder_text = "Search ID, title, source, or text"
	search.text = archive_query
	search.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_row.add_child(search)
	_button("SEARCH", func():
		archive_query = search.text.strip_edges()
		selected_document_id = ""
		_refresh()
	, search_row)
	_button("CLEAR", func():
		archive_query = ""
		selected_document_id = ""
		_refresh()
	, search_row)
	var matches: Array = []
	var query := archive_query.to_lower()
	for document in Catalog.DOCUMENTS:
		var searchable := (String(document.get("id", "")) + " " + String(document.get("title", "")) + " " + String(document.get("source", "")) + " " + String(document.get("body", ""))).to_lower()
		if query.is_empty() or searchable.contains(query):
			matches.append(document)
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
			_add_text("Status: " + String(document.get("status", "")) + "  •  Version " + str(document.get("version", 1)), 12, MUTED)
			_add_text(String(document.get("body", "")), 15, TEXT)
			_add_text("Related records: " + ", ".join(document.get("related_ids", [])), 12, MUTED)
			_add_text("Original text is retained as authored. No timestamp normalization is applied.", 12, WARNING)

func _select_document(document_id: String) -> void:
	selected_document_id = document_id
	status_message = "Opened " + document_id + ". Original record text is unchanged."
	_refresh()

func _draw_notebook() -> void:
	_heading("NOTEBOOK", "Private working notes. Notes are interpretations, not automatic facts.")
	note_editor = TextEdit.new()
	note_editor.placeholder_text = "Write a note. Link a source if useful."
	note_editor.text = String(game.data.get("note_draft", ""))
	note_editor.custom_minimum_size = Vector2(0, 100)
	note_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	note_editor.text_changed.connect(_on_note_draft_changed)
	body.add_child(note_editor)
	var source_row := _row()
	_add_text("SOURCE LINK", 12, MUTED, source_row)
	var source_select := OptionButton.new()
	source_select.add_item("No source link")
	for item in ["SIG-0004", "SIG-0005", "M-02", "M-05", "M-07", "M-08", "M-09"]:
		source_select.add_item(item)
	source_select.custom_minimum_size = Vector2(170, 38)
	source_row.add_child(source_select)
	_button("SAVE NOTE", func():
		var source_id := ""
		if source_select.selected > 0:
			source_id = source_select.get_item_text(source_select.selected)
		game.add_note(note_editor.text, source_id)
		game.data["note_draft"] = ""
		status_message = "Notebook entry saved."
		_refresh()
	, source_row)
	_add_text("SAVED NOTES", 14, ACCENT)
	if game.data.get("notes", []).is_empty():
		_add_text("No saved notes yet.", 13, MUTED)
	for note in game.data.get("notes", []):
		_add_text(String(note.get("id", "")) + (("  /  " + String(note.get("source_id", ""))) if not String(note.get("source_id", "")).is_empty() else ""), 12, MUTED)
		_add_text(String(note.get("text", "")), 15, TEXT)
		_button("DELETE " + String(note.get("id", "")), _delete_note.bind(String(note.get("id", "")))

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
	var action_row := _row()
	_button("MARK IN PROGRESS", func():
		game.data["assignments"][selected_assignment_id] = "IN PROGRESS"
		game.save_game()
		status_message = selected_assignment_id + " marked in progress."
		_refresh()
	, action_row)
	if selected_assignment_id == "A-006":
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
		_button("SUBMIT REPORT", _submit_report)
		_add_text("Submission creates a permanent report record. The assignment closes; the case thread remains unresolved.", 12, WARNING)
	if not game.data.get("reports", []).is_empty():
		_add_text("SUBMITTED REPORTS", 14, ACCENT)
		for report in game.data.get("reports", []):
			_add_text(String(report.get("id", "")) + " — " + String(report.get("status", "")) + " / Case: " + String(report.get("case_status", "")), 13, MUTED)
			_add_text(String(report.get("body", "")), 14, TEXT)

func _find_assignment(assignment_id: String) -> Dictionary:
	for assignment in Catalog.ASSIGNMENTS:
		if String(assignment.get("id", "")) == assignment_id:
			return assignment
	return {}

func _select_assignment(assignment_id: String) -> void:
	selected_assignment_id = assignment_id
	status_message = "Opened work order " + assignment_id + "."
	_refresh()

func _on_report_draft_changed() -> void:
	if report_editor != null:
		game.data["report_draft"] = report_editor.text
		game.save_game()

func _submit_report() -> void:
	var report_body := String(game.data.get("report_draft", "")).strip_edges()
	if report_body.is_empty():
		status_message = "Report not submitted: enter observations first."
		_refresh()
		return
	var recommendation := String(game.data.get("report_recommendation", "Retain records and request clock/source documentation."))
	if recommendation_select != null and recommendation_select.selected >= 0:
		recommendation = recommendation_select.get_item_text(recommendation_select.selected)
	game.data["report_recommendation"] = recommendation
	var report := game.submit_report(report_body, recommendation, ["SIG-0004", "SIG-0005", "M-02", "M-07", "M-08", "M-09"])
	game.data["current_section"] = "Messages"
	status_message = String(report.get("id", "REPORT")) + " submitted. Mara's review is now available; source remains unresolved."
	_refresh()

func _draw_messages() -> void:
	_heading("MESSAGES", "Operational correspondence and review notices.")
	for message in Catalog.MESSAGES:
		_add_text(String(message.get("sender", "")) + "  /  " + String(message.get("subject", "")), 16, ACCENT)
		var unread := not game.data.get("messages_seen", []).has(String(message.get("id", "")))
		_add_text("UNREAD" if unread else "READ", 11, WARNING if unread else MUTED)
		_add_text(String(message.get("body", "")), 15, TEXT)
		_button("MARK READ", _mark_message_read.bind(String(message.get("id", ""))))
	if not game.data.get("reports", []).is_empty():
		_add_text("MARA VENN  /  REGIONAL OPERATIONS REVIEW", 16, ACCENT)
		var response := _find_document("M-10B")
		_add_text(String(response.get("body", "")), 15, TEXT)
		_add_text("Administrative status: accepted for filing. Case status: unresolved.", 12, WARNING)
		_button("OPEN A-006 REPORT", func():
			selected_assignment_id = "A-006"
			game.data["current_section"] = "Assignments"
			game.save_game()
			_refresh()
		)
		_add_text("SHIFT CLOSED — RECORDS RETAINED — SOURCE UNRESOLVED", 17, ACCENT)

func _mark_message_read(message_id: String) -> void:
	game.mark_message_seen(message_id)
	status_message = message_id + " marked read."
	_refresh()
