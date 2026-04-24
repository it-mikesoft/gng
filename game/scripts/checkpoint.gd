extends Area2D

var activated := false
var _ph       : Node2D

const COL_IDLE   := Color(0.4, 0.7, 1.0, 0.8)
const COL_ACTIVE := Color(1.0, 0.9, 0.2, 1.0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_ph = preload("res://scripts/debug/draw_placeholder.gd").new()
	_ph.set("size",            Vector2(8, 20))
	_ph.set("color",           COL_IDLE)
	_ph.set("static_geometry", false)
	add_child(_ph)

func _on_body_entered(body: Node2D) -> void:
	if activated or not body is CharacterBody2D:
		return
	if not body.has_method("take_damage"):
		return
	activated = true
	_ph.set("color", COL_ACTIVE)
	GameManager.set_checkpoint(global_position)
	AudioManager.play_sfx("checkpoint")
