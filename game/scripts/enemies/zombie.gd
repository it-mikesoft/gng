extends EnemyBase
# Zombie: walks toward player, lunges when in range

const LUNGE_SPEED    := 160.0
const LUNGE_DURATION := 0.35
const GRAVITY        := 600.0

var lunge_timer : float = 0.0
var lunging     : bool  = false

func _ready() -> void:
	super()
	max_hp      = 1
	move_speed  = 30.0
	score_value = 100

func _update_logic(delta: float) -> void:
	_apply_gravity(delta)

	if state == State.HURT:
		state = State.PATROL
		return

	var dist := _distance_to_player()

	if lunging:
		lunge_timer -= delta
		velocity.x   = facing * LUNGE_SPEED
		if lunge_timer <= 0.0 or is_on_wall():
			lunging   = false
			velocity.x = 0.0
			state      = State.PATROL
		return

	if dist <= attack_range:
		_lunge()
	elif dist <= detect_range:
		state = State.CHASE
		_face_toward(player_ref.global_position.x)
		velocity.x = facing * move_speed
	else:
		state      = State.PATROL
		velocity.x = facing * (move_speed * 0.5)
		if is_on_wall():
			facing    = -facing
			sprite.flip_h = facing < 0

func _lunge() -> void:
	if not is_instance_valid(player_ref):
		return
	state       = State.ATTACK
	lunging     = true
	lunge_timer = LUNGE_DURATION
	_face_toward(player_ref.global_position.x)
	velocity.x  = facing * LUNGE_SPEED
	velocity.y  = -80.0

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0
