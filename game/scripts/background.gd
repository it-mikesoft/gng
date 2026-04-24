## Gothic parallax background — 3 layers drawn in code.
## Attach to a Node2D that is a child of the level (not the camera).
extends Node2D

const VIEWPORT_W : float = 320.0
const VIEWPORT_H : float = 180.0
const LEVEL_W    : float = 1280.0

# Layer definitions: [color, parallax_ratio, y_start, height, draw_fn]
# Drawn back-to-front. Ratio 0.0 = fixed, 1.0 = moves with camera.

var _cam_x : float = 0.0

# Gothic palette
const COL_SKY_FAR   := Color(0.06, 0.04, 0.15)   # deep night purple
const COL_SKY_MID   := Color(0.09, 0.06, 0.22)
const COL_MTN_FAR   := Color(0.10, 0.07, 0.18)   # distant silhouette
const COL_MTN_NEAR  := Color(0.07, 0.05, 0.12)   # closer mountains
const COL_RUIN_FAR  := Color(0.08, 0.06, 0.14)
const COL_RUIN_NEAR := Color(0.05, 0.04, 0.10)
const COL_MOON      := Color(0.78, 0.75, 0.65)   # bone-white moon

func _process(_delta: float) -> void:
	var cam : Camera2D = get_viewport().get_camera_2d()
	if cam:
		_cam_x = cam.global_position.x
	queue_redraw()

func _draw() -> void:
	var vp := get_viewport_rect().size
	_draw_sky(vp)
	_draw_moon(vp)
	_draw_mountains_far(vp)
	_draw_ruins_far(vp)
	_draw_mountains_near(vp)
	_draw_ruins_near(vp)

func _scroll(ratio: float) -> float:
	return -_cam_x * ratio

func _draw_sky(vp: Vector2) -> void:
	draw_rect(Rect2(Vector2.ZERO, vp), COL_SKY_FAR)
	# Slight gradient from top to bottom via two rects
	draw_rect(Rect2(0, vp.y * 0.5, vp.x, vp.y * 0.5), COL_SKY_MID)

func _draw_moon(vp: Vector2) -> void:
	var ox := _scroll(0.05) + vp.x * 0.75
	# Wrap moon within a wide range
	ox = fmod(ox + LEVEL_W, LEVEL_W + vp.x) - vp.x * 0.5
	draw_circle(Vector2(fmod(ox, vp.x + 60) , 28), 14, COL_MOON)
	# Dark overlay for crescent
	draw_circle(Vector2(fmod(ox, vp.x + 60) + 6, 26), 12, COL_SKY_FAR)

func _draw_mountains_far(vp: Vector2) -> void:
	var ox := _scroll(0.10)
	var pts := _mountain_poly(ox, vp, 5, 80, 55, 1234)
	if pts.size() >= 3:
		draw_colored_polygon(pts, COL_MTN_FAR)

func _draw_ruins_far(vp: Vector2) -> void:
	var ox := _scroll(0.15)
	_draw_castle_silhouette(ox, vp, 60, 70, 40, COL_RUIN_FAR)

func _draw_mountains_near(vp: Vector2) -> void:
	var ox := _scroll(0.25)
	var pts := _mountain_poly(ox, vp, 7, 65, 42, 5678)
	if pts.size() >= 3:
		draw_colored_polygon(pts, COL_MTN_NEAR)

func _draw_ruins_near(vp: Vector2) -> void:
	var ox := _scroll(0.35)
	_draw_castle_silhouette(ox, vp, 20, 55, 30, COL_RUIN_NEAR)

func _mountain_poly(ox: float, vp: Vector2, count: int,
		peak_h: float, base_y: float, seed_val: int) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var step : float = (vp.x + 120) / count
	pts.append(Vector2(0, vp.y))
	for i in range(count + 2):
		var x : float = fmod(i * step + ox, vp.x + 120) - 60
		# Deterministic "random" height from seed
		var h : float = peak_h * (0.5 + 0.5 * sin(float(i * 137 + seed_val) * 0.618))
		pts.append(Vector2(x, vp.y - base_y - h))
		if i < count + 1:
			pts.append(Vector2(x + step * 0.5, vp.y - base_y - h * 0.3))
	pts.append(Vector2(vp.x, vp.y))
	return pts

func _draw_castle_silhouette(ox: float, vp: Vector2,
		y_floor: float, tower_h: float, width: float, col: Color) -> void:
	# Draw a few repeating castle tower silhouettes
	var spacing := 200.0
	var count   := int(vp.x / spacing) + 3
	for i in range(count):
		var bx : float = fmod(float(i) * spacing + ox, vp.x + spacing) - spacing
		var by : float = vp.y - y_floor
		# Main tower body
		draw_rect(Rect2(bx, by - tower_h, width, tower_h + y_floor), col)
		# Battlements
		var merlon_w := width / 5.0
		for m in range(3):
			draw_rect(Rect2(bx + m * merlon_w * 1.5, by - tower_h - 8, merlon_w, 8), col)
		# Narrow window slit
		draw_rect(Rect2(bx + width * 0.4, by - tower_h * 0.6, width * 0.2, tower_h * 0.25),
			COL_SKY_FAR)
