extends CharacterBody2D

enum State { IDLE, WALK, JUMP, FALL, HURT, DEAD }

# Tuning — from BDR-002
const WALK_SPEED    := 80.0
const JUMP_VELOCITY := -280.0
const GRAVITY       := 600.0
const KNOCKBACK     := Vector2(100.0, -160.0)
const IFRAMES_DUR   := 2.0
const BLINK_RATE    := 0.1

@export var weapon_scene: PackedScene

@onready var sprite        : AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_spawn  : Marker2D         = $WeaponSpawn
@onready var hurtbox       : Area2D           = $Hurtbox

var state       : State = State.IDLE
var facing      : int   = 1          # 1 = right, -1 = left
var jump_hvel   : float = 0.0        # locked horizontal vel on jump
var airborne    : bool  = false
var invincible  : bool  = false
var iframes_t   : float = 0.0
var blink_t     : float = 0.0

func _ready() -> void:
	add_to_group("player")
	GameManager.register_player(self)
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	if sprite.sprite_frames == null:
		sprite.hide()

func _physics_process(delta: float) -> void:
	match state:
		State.DEAD:
			return
		State.HURT:
			_apply_gravity(delta)
			move_and_slide()
			if is_on_floor():
				state = State.IDLE
			_tick_iframes(delta)
			return

	_apply_gravity(delta)
	_handle_horizontal()
	_handle_jump()
	_handle_attack()
	move_and_slide()
	_update_state()
	_tick_iframes(delta)

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func _handle_horizontal() -> void:
	if airborne:
		# GNG commitment: horizontal locked to jump-start velocity
		velocity.x = jump_hvel
		return
	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * WALK_SPEED
	if dir != 0:
		facing = int(sign(dir))
		sprite.flip_h = facing < 0

func _handle_jump() -> void:
	if is_on_floor() and airborne:
		airborne = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_hvel  = velocity.x   # lock current horizontal
		airborne   = true

func _handle_attack() -> void:
	if not Input.is_action_just_pressed("attack"):
		return
	if weapon_scene == null:
		return
	var w: Node2D = weapon_scene.instantiate()
	get_parent().add_child(w)
	w.global_position = weapon_spawn.global_position
	w.set_direction(facing)

func _update_state() -> void:
	if is_on_floor():
		state = State.WALK if velocity.x != 0.0 else State.IDLE
	else:
		state = State.JUMP if velocity.y < 0.0 else State.FALL

func _tick_iframes(delta: float) -> void:
	if not invincible:
		return
	iframes_t -= delta
	blink_t   -= delta
	if blink_t <= 0.0:
		blink_t         = BLINK_RATE
		sprite.visible  = not sprite.visible
	if iframes_t <= 0.0:
		invincible     = false
		sprite.visible = true

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("get_knockback_dir"):
		take_damage(body.get_knockback_dir(global_position))
	else:
		take_damage(1)

func take_damage(knock_dir: int = 1) -> void:
	if invincible or state == State.DEAD:
		return
	GameManager.lose_life()
	if GameManager.lives <= 0:
		_die()
		return
	state      = State.HURT
	invincible = true
	iframes_t  = IFRAMES_DUR
	blink_t    = BLINK_RATE
	velocity   = Vector2(knock_dir * KNOCKBACK.x, KNOCKBACK.y)

func _die() -> void:
	state          = State.DEAD
	velocity       = Vector2.ZERO
	sprite.visible = true
	GameManager.on_player_died()

func respawn() -> void:
	state      = State.IDLE
	velocity   = Vector2.ZERO
	invincible = true
	iframes_t  = IFRAMES_DUR
	blink_t    = BLINK_RATE
	airborne   = false
