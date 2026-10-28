extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var script_resource = ResourceLoader.load("res://scripts/main.gd", "GDScript", ResourceLoader.CACHE_MODE_IGNORE)
	if script_resource == null:
		push_error("Main GDScript failed to parse.")
		quit(1)
		return
	var state_script = ResourceLoader.load("res://scripts/game_state.gd", "GDScript", ResourceLoader.CACHE_MODE_IGNORE)
	if state_script == null:
		push_error("Game state GDScript failed to parse.")
		quit(1)
		return
	var catalog_script = ResourceLoader.load("res://scripts/content_catalog.gd", "GDScript", ResourceLoader.CACHE_MODE_IGNORE)
	if catalog_script == null:
		push_error("Content catalog GDScript failed to parse.")
		quit(1)
		return
	var packed = ResourceLoader.load("res://scenes/main.tscn", "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
	if packed == null:
		push_error("Main scene failed to load.")
		quit(1)
		return
	var instance = packed.instantiate()
	if instance == null:
		push_error("Main scene failed to instantiate.")
		quit(1)
		return
	root.add_child(instance)
	await process_frame
	if instance.get_child_count() < 2:
		push_error("Main scene did not construct the expected workstation shell.")
		quit(1)
		return
	print("DEAD AIR project parse/startup check passed.")
	quit(0)
