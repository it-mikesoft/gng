extends EnemyBase
# Crow: flying, swoops diagonally toward player then resets

enum CrowState { PERCHED, SWOOPING, RETREATING }

const SWOOP_SPEED   := 120.0
const RETREAT_SPEED := 60.0

var crow_state  : CrowState = CrowState.PERCHED
var origin_pos  : Vector2   = Vector2.ZERO
var swoop_dir   : Vector2   = Vector2.ZERO
var trigger_dist: float     = 80.0

func _ready() -> void:
	super()
	max_hp      = 1
	move_speed  = 120.0
	score_value = 200
	origin_pos  = global_position

func _update_logic(delta: float) -> void:
	match crow_state:
		CrowState.PERCHED:
			velocity = Vector2.ZERO
			if _distance_to_player() <= trigger_dist:
				_start_swoop()
		CrowState.SWOOPING:
			velocity = swoop_dir * SWOOP_SPEED
			if _distance_to_player() <= attack_range or _past_player():
				crow_state = CrowState.RETREATING
		CrowState.RETREATING:
			var to_origin := (origin_pos - global_position)
			if to_origin.length() < 4.0:
				global_position = origin_pos
				crow_state      = CrowState.PERCHED
				velocity        = Vector2.ZERO
			else:
				velocity = to_origin.normalized() * RETREAT_SPEED

func _start_swoop() -> void:
	if not is_instance_valid(player_ref):
		return
	crow_state = CrowState.SWOOPING
	swoop_dir  = (player_ref.global_position - global_position).normalized()
	_face_toward(player_ref.global_position.x)

func _past_player() -> bool:
	if not is_instance_valid(player_ref):
		return true
	var dot := swoop_dir.dot(player_ref.global_position - global_position)
	return dot < 0.0
