## Attach to any Node2D to draw a colored debug rect.
## Remove once real sprites land.
extends Node2D

@export var color : Color = Color.MAGENTA
@export var size  : Vector2 = Vector2(16, 24)

func _draw() -> void:
	draw_rect(Rect2(-size * 0.5, size), color, true)
	draw_rect(Rect2(-size * 0.5, size), Color.BLACK, false)
