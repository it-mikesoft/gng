extends EnemyBase
# Red Arremer: hovering, stalks player position then dives + claws

enum ArremerState { HOVER, STALK, DIVE, CLAW, RETREAT }

const HOVER_AMPLITUDE : float = 8.0
const HOVER_SPEED     : float = 2.0
const STALK_SPEED     : float = 50.0
const DIVE_SPEED      : float = 180.0
const CLAW_DURATION   : float = 0.4
const RETREAT_SPEED   : float = 70.0
const STALK_OFFSET    : Vector2 = Vector2(0, -48)  # hover above player

var arremer_state : ArremerState = ArremerState.HOVER
var hover_t       : float        = 0.0
var origin_pos    : Vector2      = Vector2.ZERO
var claw_timer    : float        = 0.0
var dive_dir      : Vector2      = Vector2.ZERO

func _ready() -> void:
	super()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	max_hp      = 2
	move_speed  = 50.0
	score_value = 1000
	hp          = max_hp
	origin_pos  = global_position

func _update_logic(delta: float) -> void:
	hover_t += delta
	match arremer_state:
		ArremerState.HOVER:
			_do_hover(delta)
		ArremerState.STALK:
			_do_stalk(delta)
		ArremerState.DIVE:
			_do_dive(delta)
		ArremerState.CLAW:
			_do_claw(delta)
		ArremerState.RETREAT:
			_do_retreat(delta)

func _do_hover(delta: float) -> void:
	velocity = Vector2.ZERO
	global_position.y = origin_pos.y + sin(hover_t * HOVER_SPEED) * HOVER_AMPLITUDE
	if _distance_to_player() <= detect_range:
		arremer_state = ArremerState.STALK

func _do_stalk(delta: float) -> void:
	if not is_instance_valid(player_ref):
		return
	var target := player_ref.global_position + STALK_OFFSET
	var to_target := target - global_position
	if to_target.length() < 6.0:
		# Positioned above player — dive
		_start_dive()
	else:
		velocity = to_target.normalized() * STALK_SPEED
		_face_toward(player_ref.global_position.x)

func _start_dive() -> void:
	if not is_instance_valid(player_ref):
		return
	arremer_state = ArremerState.DIVE
	dive_dir      = (player_ref.global_position - global_position).normalized()
	_face_toward(player_ref.global_position.x)

func _do_dive(delta: float) -> void:
	velocity = dive_dir * DIVE_SPEED
	if _distance_to_player() <= attack_range:
		arremer_state = ArremerState.CLAW
		claw_timer    = CLAW_DURATION
		velocity      = Vector2.ZERO

func _do_claw(delta: float) -> void:
	velocity    = Vector2.ZERO
	claw_timer -= delta
	if claw_timer <= 0.0:
		arremer_state = ArremerState.RETREAT

func _do_retreat(delta: float) -> void:
	var to_origin := origin_pos - global_position
	if to_origin.length() < 4.0:
		global_position = origin_pos
		arremer_state   = ArremerState.HOVER
		velocity        = Vector2.ZERO
	else:
		velocity = to_origin.normalized() * RETREAT_SPEED
