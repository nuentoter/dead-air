extends Control
## Visual-only synthetic receiver waterfall. Does not create evidence or change gameplay.
## Frequency and power come from the authoritative game state.
var frequency_mhz := 7.285
var powered := false
var frozen := false
var elapsed := 0.0
var rows: Array[PackedFloat32Array] = []
const COLS := 128
const ROWS := 68
const FRAME := 0.10

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_process(true)

func _process(delta: float) -> void:
	if not powered or frozen:
		return
	elapsed += delta
	if elapsed < FRAME:
		return
	elapsed = fmod(elapsed, FRAME)
	var row := PackedFloat32Array()
	row.resize(COLS)
	var t := float(Time.get_ticks_msec()) / 1000.0
	for i in COLS:
		var x := float(i) / float(COLS - 1)
		var noise := 0.06 + 0.11 * absf(sin(float(i) * 7.39 + t * 0.77) * cos(float(i) * 1.87 - t))
		var center := 0.5 + 0.19 * sin(frequency_mhz * 1.713)
		var narrow := exp(-pow((x - center) / 0.018, 2.0))
		var side := exp(-pow((x - (center + 0.16)) / 0.035, 2.0)) * 0.35
		row[i] = clampf(noise + narrow * 0.83 + side, 0.0, 1.0)
	rows.push_front(row)
	if rows.size() > ROWS:
		rows.pop_back()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.008, 0.025, 0.027), true)
	if not powered:
		return
	var cw := size.x / float(COLS)
	var rh := size.y / float(ROWS)
	for y in rows.size():
		for x in COLS:
			var v := rows[y][x]
			var tint := Color(0.018 + v * 0.50, 0.055 + v * 0.90, 0.065 + v * 0.25, 1.0)
			if v > 0.77:
				tint = Color(0.63 + (v - 0.77), 0.95, 0.28, 1.0)
			draw_rect(Rect2(float(x) * cw, float(y) * rh, cw + 0.35, rh + 0.35), tint, true)
	draw_line(Vector2(size.x * 0.5, 0), Vector2(size.x * 0.5, size.y), Color(0.38, 0.95, 0.46, 0.45), 1.0)
