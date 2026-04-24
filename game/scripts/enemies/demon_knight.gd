extends EnemyBase
# Demon Knight: patrols, raises shield when hit from front, throws spear

const GRAVITY         := 600.0
const SHIELD_DURATION := 1.5
const ATTACK_COOLDOWN := 2.5
const SPEAR_SPEED     := 150.0

@export var spear_scene : PackedScene

var shielded       : bool  = false
var shield_timer   : float = 0.0
var attack_cooldown: float = 0.0

func _ready() -> void:
	super()
	max_hp      = 3
	move_speed  = 25.0
	score_value = 500
	hp          = max_hp
	if spear_scene == null:
		spear_scene = load("res://scenes/weapons/lance.tscn")

func _load_sprites() -> void:
	var sf := SpriteLoader.make_frames(
		"res://assets/sprites/enemies/demon_knight_walk.png", "walk", 4, 28, 48, 6.0)
	sprite.sprite_frames = sf
	sprite.offset        = Vector2(0, -24)
	sprite.show()
	sprite.play("walk")

func _placeholder_color() -> Color: return Color(0.4, 0.1, 0.5)

func _update_logic(delta: float) -> void:
	_apply_gravity(delta)
	_tick_timers(delta)

	if state == State.HURT:
		state = State.PATROL

	var dist := _distance_to_player()

	if dist <= detect_range:
		_face_toward(player_ref.global_position.x)
		state = State.CHASE
	else:
		state = State.PATROL
		if is_on_wall():
			facing    = -facing
			sprite.flip_h = facing < 0

	if state == State.CHASE and dist <= 80.0 and attack_cooldown <= 0.0:
		_throw_spear()
	else:
		velocity.x = facing * move_speed

func take_damage(amount: int = 1) -> void:
	# Shield blocks frontal hits
	if shielded and _hit_from_front():
		_raise_shield()
		return
	super(amount)
	if hp > 0:
		_raise_shield()

func _raise_shield() -> void:
	shielded     = true
	shield_timer = SHIELD_DURATION
	velocity.x   = 0.0

func _throw_spear() -> void:
	state           = State.ATTACK
	attack_cooldown = ATTACK_COOLDOWN
	velocity.x      = 0.0
	if spear_scene == null:
		return
	var s : Node2D = spear_scene.instantiate()
	get_parent().add_child(s)
	s.global_position = global_position + Vector2(facing * 14, 0)
	s.set("target_group", "player")
	s.set_direction(facing)

func _hit_from_front() -> bool:
	if not is_instance_valid(player_ref):
		return false
	var player_side := 1 if player_ref.global_position.x > global_position.x else -1
	return player_side == facing

func _tick_timers(delta: float) -> void:
	if shielded:
		shield_timer -= delta
		if shield_timer <= 0.0:
			shielded = false
	if attack_cooldown > 0.0:
		attack_cooldown -= delta

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0
