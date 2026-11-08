extends Control
## Tiny startup guard. Independent of DEAD AIR's main receiver scripts.
## Keeps a visible diagnostic screen when the main scene cannot initialize.
var status: Label
var started := false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.025, 0.045, 0.052)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	var column := VBoxContainer.new()
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_left = 32
	column.offset_top = 32
	column.offset_right = -32
	column.offset_bottom = -32
	column.add_theme_constant_override("separation", 16)
	add_child(column)

	var heading := Label.new()
	heading.text = "DEAD AIR / SYSTEM STARTUP"
	heading.add_theme_font_size_override("font_size", 28)
	heading.add_theme_color_override("font_color", Color(0.49, 0.90, 0.69))
	column.add_child(heading)

	status = Label.new()
	status.text = "Loading local investigation..."
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_font_size_override("font_size", 18)
	status.add_theme_color_override("font_color", Color(0.92, 0.88, 0.68))
	column.add_child(status)

	var retry := Button.new()
	retry.text = "RETRY STARTUP"
	retry.custom_minimum_size = Vector2(240, 60)
	retry.pressed.connect(_try_launch)
	column.add_child(retry)

	var instructions := Label.new()
	instructions.text = "If this message remains, the game did not initialize. Please report the error text. Existing local save data has not been erased."
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instructions.add_theme_color_override("font_color", Color(0.58, 0.72, 0.70))
	column.add_child(instructions)

	call_deferred("_try_launch")

func _try_launch() -> void:
	if started:
		return
	started = true
	status.text = "Starting live receiver..."
	for candidate_path in ["res://scenes/main_live_recovery.tscn", "res://scenes/main_recovery.tscn"]:
		var packed := load(candidate_path) as PackedScene
		if packed == null:
			continue
		var instance := packed.instantiate() as Control
		if instance == null:
			continue
		# A missing controller is a recoverable candidate failure.
		if instance.get_script() == null or not instance.has_method("_refresh"):
			instance.free()
			continue
		instance.visible = false
		add_child(instance)
		await get_tree().process_frame
		if not is_instance_valid(instance):
			continue
		var game_state = instance.get("game")
		var standard_ui = instance.get("root_column")
		if game_state == null or standard_ui == null:
			instance.queue_free()
			continue
		var using_live := candidate_path == "res://scenes/main_live_recovery.tscn"
		if using_live and not instance.has_method("_sync_live_plot"):
			instance.queue_free()
			continue
		instance.set("status_message", "LIVE WATERFALL TEST — synthetic signal display." if using_live else "RECOVERY FALLBACK — standard receiver.")
		instance.call("_refresh")
		instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		instance.visible = true
		status.text = "Live receiver ready." if using_live else "Recovered standard receiver."
		return
	_failure("NO GAME CONTROLLER INITIALIZED. Recovery scene unavailable.")

func _failure(message: String) -> void:
	started = false
	status.text = message
	push_error("DEAD AIR startup: " + message)
