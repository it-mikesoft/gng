extends CharacterBody2D
class_name EnemyBase

signal died(enemy: Node)

enum State { IDLE, PATROL, CHASE, ATTACK, HURT, DEAD }

@export var max_hp        : int     = 1
@export var move_speed    : float   = 40.0
@export var detect_range  : float   = 120.0
@export var attack_range  : float   = 16.0
@export var score_value   : int     = 100
@export var collision_size: Vector2 = Vector2(14, 24)

var hp         : int   = 1
var state      : State = State.PATROL
var facing     : int   = 1
var player_ref : CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hp         = max_hp
	player_ref = get_tree().get_first_node_in_group("player") as CharacterBody2D
	_auto_shapes()
	_load_sprites()
	if sprite.sprite_frames == null:
		sprite.hide()
		_add_placeholder()

func _auto_shapes() -> void:
	var cs : CollisionShape2D = get_node_or_null("CollisionShape2D")
	if cs and cs.shape == null:
		var s := RectangleShape2D.new()
		s.size = collision_size
		cs.shape = s
	var hb : CollisionShape2D = get_node_or_null("Hitbox/CollisionShape2D")
	if hb and hb.shape == null:
		var s := RectangleShape2D.new()
		s.size = collision_size
		hb.shape = s

func _load_sprites() -> void:
	pass  # override in subclass

func _add_placeholder() -> void:
	var ph : Node2D = preload("res://scripts/debug/draw_placeholder.gd").new()
	ph.set("size",            collision_size)
	ph.set("color",           _placeholder_color())
	ph.set("static_geometry", false)
	add_child(ph)

func _placeholder_color() -> Color:
	return Color.MAGENTA

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_update_logic(delta)
	move_and_slide()

func _update_logic(_delta: float) -> void:
	pass

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
	GameManager.add_score(score_value)
	AudioManager.play_sfx("enemy_die")
	died.emit(self)
	queue_free()
