extends Node

signal lives_changed(count: int)
signal game_over
signal player_respawning

const MAX_LIVES := 3

var lives := MAX_LIVES
var checkpoint_pos := Vector2.ZERO
var player: CharacterBody2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func register_player(p: CharacterBody2D) -> void:
	player = p

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_pos = pos

func lose_life() -> void:
	lives = max(0, lives - 1)
	lives_changed.emit(lives)

func on_player_died() -> void:
	if lives <= 0:
		game_over.emit()
		return
	player_respawning.emit()
	await get_tree().create_timer(1.5).timeout
	_respawn()

func _respawn() -> void:
	if not is_instance_valid(player):
		return
	player.global_position = checkpoint_pos
	player.respawn()

func reset() -> void:
	lives = MAX_LIVES
	checkpoint_pos = Vector2.ZERO
	lives_changed.emit(lives)
