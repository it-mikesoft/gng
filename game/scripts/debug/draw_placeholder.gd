## Colored rect placeholder. Remove once real sprites land.
extends Node2D

@export var color  : Color   = Color.MAGENTA
@export var size   : Vector2 = Vector2(16, 24)
@export var static_geometry : bool = false  # true = skip queue_redraw each frame

func _process(_delta: float) -> void:
	if not static_geometry:
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(-size * 0.5, size), color, true)
	draw_rect(Rect2(-size * 0.5, size), Color(0, 0, 0, 1), false)
