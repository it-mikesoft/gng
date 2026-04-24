extends Node2D

var _blink_t : float = 0.0
var _show    : bool  = true

@onready var press_label : Label = $PressLabel

func _ready() -> void:
	AudioManager.play_music("level")

func _process(delta: float) -> void:
	_blink_t += delta
	if _blink_t >= 0.5:
		_blink_t = 0.0
		_show    = not _show
		press_label.visible = _show
	_draw_bg()

func _draw_bg() -> void:
	queue_redraw()

func _draw() -> void:
	var vp := get_viewport_rect().size
	# Sky
	draw_rect(Rect2(Vector2.ZERO, vp), Color(0.06, 0.04, 0.15))
	draw_rect(Rect2(0, vp.y * 0.5, vp.x, vp.y * 0.5), Color(0.09, 0.06, 0.22))
	# Moon
	draw_circle(Vector2(vp.x * 0.8, 30), 14, Color(0.78, 0.75, 0.65))
	draw_circle(Vector2(vp.x * 0.8 + 6, 28), 12, Color(0.06, 0.04, 0.15))
	# Ground silhouette
	draw_rect(Rect2(0, vp.y - 20, vp.x, 20), Color(0.07, 0.05, 0.12))

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		AudioManager.stop_music()
		get_tree().change_scene_to_file("res://scenes/level/level_01.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		AudioManager.stop_music()
		get_tree().change_scene_to_file("res://scenes/level/level_01.tscn")
