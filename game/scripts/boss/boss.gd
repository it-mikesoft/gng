extends CharacterBody2D
class_name Boss

signal phase_changed(new_phase: int)
signal defeated

enum Phase { ONE, TWO }
enum BossState { ENTER, ADVANCE, SHOOT, JUMP, SLAM, STUNNED, DEAD }

const MAX_HP := 20
const PHASE_TWO_THRESHOLD := 10

# Phase 1
const P1_SPEED          := 35.0
const P1_SHOOT_COOLDOWN := 3.5
const P1_JUMP_COOLDOWN  := 6.0
const P1_JUMP_VEL       := -320.0

# Phase 2
const P2_SPEED          := 65.0
const P2_SHOOT_COOLDOWN := 1.8
const P2_JUMP_COOLDOWN  := 3.5
const P2_JUMP_VEL       := -360.0

const GRAVITY           := 600.0
const SLAM_SHOCKWAVE_W  := 80.0
const STUN_DURATION     := 0.4

@export var projectile_scene : PackedScene
@export var arena_left_x    : float = 20.0
@export var arena_right_x   : float = 300.0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var hp            : int       = MAX_HP
var phase         : Phase     = Phase.ONE
var state         : BossState = BossState.ENTER
var facing        : int       = -1
var shoot_timer   : float     = 0.0
var jump_timer    : float     = 0.0
var stun_timer    : float     = 0.0
var _player       : CharacterBody2D
var _entered      : bool      = false

func _ready() -> void:
	hp      = MAX_HP
	_player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if projectile_scene == null:
		projectile_scene = load("res://scenes/boss/boss_projectile.tscn")
	_auto_shapes()
	_load_sprites()

func _load_sprites() -> void:
	var sf := SpriteLoader.make_frames(
		"res://assets/sprites/boss/boss_p1.png", "p1", 2, 64, 96, 4.0)
	SpriteLoader.add_anim(sf,
		"res://assets/sprites/boss/boss_p2.png", "p2", 2, 64, 96, 6.0)
	sprite.sprite_frames = sf
	sprite.offset        = Vector2(0, -48)
	sprite.show()
	sprite.play("p1")

func _auto_shapes() -> void:
	var cs : CollisionShape2D = get_node_or_null("CollisionShape2D")
	if cs and cs.shape == null:
		var s := RectangleShape2D.new()
		s.size = Vector2(28, 44)
		cs.shape = s
	var hb : CollisionShape2D = get_node_or_null("Hitbox/CollisionShape2D")
	if hb and hb.shape == null:
		var s := RectangleShape2D.new()
		s.size = Vector2(28, 44)
		hb.shape = s

func _physics_process(delta: float) -> void:
	if state == BossState.DEAD:
		return

	_apply_gravity(delta)

	match state:
		BossState.ENTER:    _do_enter()
		BossState.ADVANCE:  _do_advance(delta)
		BossState.SHOOT:    _do_shoot(delta)
		BossState.JUMP:     _do_jump(delta)
		BossState.SLAM:     _do_slam(delta)
		BossState.STUNNED:  _do_stunned(delta)

	move_and_slide()

func _do_enter() -> void:
	if not _entered:
		_entered = true
		GameManager.set_checkpoint(global_position + Vector2(-60, 0))
		AudioManager.play_music("boss")
	state = BossState.ADVANCE

func _do_advance(delta: float) -> void:
	_tick_cooldowns(delta)
	if not is_instance_valid(_player):
		return

	_face_player()
	var dist : float = absf(_player.global_position.x - global_position.x)

	if shoot_timer <= 0.0 and dist < 200.0:
		_begin_shoot()
		return

	if jump_timer <= 0.0 and is_on_floor():
		_begin_jump()
		return

	# Walk toward player but stay within arena
	var target_x := _player.global_position.x - facing * 60.0
	target_x = clampf(target_x, arena_left_x, arena_right_x)
	var spd   := P2_SPEED if phase == Phase.TWO else P1_SPEED
	velocity.x = facing * spd if abs(global_position.x - target_x) > 4.0 else 0.0

func _do_shoot(delta: float) -> void:
	# Fire then return to advance — actual shot triggered once
	state = BossState.ADVANCE

func _do_jump(delta: float) -> void:
	if is_on_floor() and velocity.y == 0.0:
		var jv := P2_JUMP_VEL if phase == Phase.TWO else P1_JUMP_VEL
		velocity.y = jv
		_face_player()
		velocity.x = facing * (P2_SPEED if phase == Phase.TWO else P1_SPEED) * 1.5
	elif is_on_floor() and velocity.y >= 0.0:
		_begin_slam()

func _do_slam(delta: float) -> void:
	# Landing shockwave — spawn hazard area briefly
	velocity.x = 0.0
	state       = BossState.ADVANCE

func _do_stunned(delta: float) -> void:
	stun_timer -= delta
	velocity.x  = 0.0
	if stun_timer <= 0.0:
		state = BossState.ADVANCE

func _begin_shoot() -> void:
	state       = BossState.SHOOT
	shoot_timer = P2_SHOOT_COOLDOWN if phase == Phase.TWO else P1_SHOOT_COOLDOWN
	_fire_volley()

func _begin_jump() -> void:
	state      = BossState.JUMP
	jump_timer = P2_JUMP_COOLDOWN if phase == Phase.TWO else P1_JUMP_COOLDOWN

func _begin_slam() -> void:
	state = BossState.SLAM
	_spawn_shockwave()

func _fire_volley() -> void:
	if projectile_scene == null or not is_instance_valid(_player):
		return
	var count := 5 if phase == Phase.TWO else 3
	var spread_step := 20.0
	var base_angle  := (_player.global_position - global_position).angle()
	var half        := (count - 1) / 2.0
	for i in range(count):
		var angle := base_angle + deg_to_rad((i - half) * spread_step)
		var p : Node2D = projectile_scene.instantiate()
		get_parent().add_child(p)
		p.global_position = global_position
		p.set_velocity_from_angle(angle)

func _spawn_shockwave() -> void:
	# Minimal inline shockwave: Area2D that hurts player briefly
	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var rect  := RectangleShape2D.new()
	rect.size = Vector2(SLAM_SHOCKWAVE_W, 12)
	shape.shape = rect
	area.add_child(shape)
	area.position = global_position + Vector2(0, 8)
	get_parent().add_child(area)
	area.body_entered.connect(func(b):
		if b.has_method("take_damage"): b.take_damage(facing))
	get_tree().create_timer(0.3).timeout.connect(area.queue_free)

func _tick_cooldowns(delta: float) -> void:
	shoot_timer = max(0.0, shoot_timer - delta)
	jump_timer  = max(0.0, jump_timer  - delta)

func _face_player() -> void:
	if not is_instance_valid(_player):
		return
	facing        = 1 if _player.global_position.x > global_position.x else -1
	sprite.flip_h = facing < 0

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if state == BossState.JUMP and velocity.y >= 0.0:
			_begin_slam()
		if state != BossState.SLAM:
			velocity.y = 0.0

func take_damage(amount: int = 1) -> void:
	if state == BossState.DEAD:
		return
	hp -= amount
	AudioManager.play_sfx("boss_hit")
	stun_timer = STUN_DURATION
	state      = BossState.STUNNED

	if hp <= 0:
		_die()
		return

	if phase == Phase.ONE and hp <= PHASE_TWO_THRESHOLD:
		_enter_phase_two()

func _enter_phase_two() -> void:
	phase = Phase.TWO
	phase_changed.emit(2)
	stun_timer = 1.5
	state      = BossState.STUNNED
	sprite.play("p2")

func _die() -> void:
	state = BossState.DEAD
	velocity = Vector2.ZERO
	defeated.emit()
	# Delay before removing — play death anim
	get_tree().create_timer(2.0).timeout.connect(queue_free)

func get_knockback_dir(from_pos: Vector2) -> int:
	return 1 if from_pos.x < global_position.x else -1
