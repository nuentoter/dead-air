extends SceneTree
## Guard against blank Android startup: boot must mount the main controller.
func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed: PackedScene = load("res://scenes/boot.tscn")
	if packed == null:
		push_error("BOOT FAIL: scenes/boot.tscn is not loadable")
		quit(1)
		return
	var boot: Control = packed.instantiate()
	root.add_child(boot)
	await process_frame
	await process_frame
	await process_frame
	var loaded := boot.get_node_or_null("DeadAir")
	if loaded == null:
		push_error("BOOT FAIL: DeadAir game did not mount; main.gd may have a parse or runtime error")
		quit(1)
		return
	if not loaded.visible:
		push_error("BOOT FAIL: DeadAir main scene remained invisible")
		quit(1)
		return
	var state = loaded.get("game")
	var standard_ui = loaded.get("root_column")
	if state == null or standard_ui == null or not standard_ui.visible:
		push_error("BOOT FAIL: Standard receiver shell unavailable")
		quit(1)
		return
	print("PASS: Android startup reached visible standard receiver UI")
	quit(0)
