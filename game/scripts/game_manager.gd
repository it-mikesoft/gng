extends Node

signal lives_changed(count: int)
signal score_changed(score: int)
signal game_over
signal player_respawning
signal game_won
signal boss_hp_changed(current: int, maximum: int)
signal boss_phase_changed(phase: int)

const MAX_LIVES := 3

var lives     : int    = MAX_LIVES
var score     : int    = 0
var checkpoint_pos := Vector2.ZERO
var player    : CharacterBody2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func register_player(p: CharacterBody2D) -> void:
	player = p

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_pos = pos

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

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

func update_boss_hp(current: int, maximum: int) -> void:
	boss_hp_changed.emit(current, maximum)

func announce_boss_phase(phase: int) -> void:
	boss_phase_changed.emit(phase)

func on_boss_defeated() -> void:
	boss_hp_changed.emit(0, 1)
	game_won.emit()

func _respawn() -> void:
	if not is_instance_valid(player):
		return
	player.global_position = checkpoint_pos
	player.respawn()

func reset() -> void:
	lives = MAX_LIVES
	score = 0
	checkpoint_pos = Vector2.ZERO
	lives_changed.emit(lives)
	score_changed.emit(score)
