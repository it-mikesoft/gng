extends CharacterBody2D
class_name EnemyBase

signal died(enemy: EnemyBase)

enum State { IDLE, PATROL, CHASE, ATTACK, HURT, DEAD }

@export var max_hp       : int   = 1
@export var move_speed   : float = 40.0
@export var detect_range : float = 120.0
@export var attack_range : float = 16.0
@export var score_value  : int   = 100

var hp         : int   = max_hp
var state      : State = State.PATROL
var facing     : int   = 1
var player_ref : CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hp         = max_hp
	player_ref = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_update_logic(delta)
	move_and_slide()

func _update_logic(_delta: float) -> void:
	pass  # override per enemy type

func _face_toward(target_x: float) -> void:
	facing        = 1 if target_x > global_position.x else -1
	sprite.flip_h = facing < 0

func _distance_to_player() -> float:
	if not is_instance_valid(player_ref):
		return INF
	return global_position.distance_to(player_ref.global_position)

func take_damage(amount: int = 1) -> void:
	if state == State.DEAD:
		return
	hp -= amount
	if hp <= 0:
		_die()
	else:
		state = State.HURT

func get_knockback_dir(from_pos: Vector2) -> int:
	return 1 if from_pos.x < global_position.x else -1

func _die() -> void:
	state = State.DEAD
	died.emit(self)
	queue_free()
