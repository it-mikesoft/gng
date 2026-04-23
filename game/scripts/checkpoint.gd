extends Area2D

var activated := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if activated or not body is CharacterBody2D:
		return
	if not body.has_method("take_damage"):
		return
	activated = true
	GameManager.set_checkpoint(global_position)
	# Placeholder: play activation animation / SFX here
