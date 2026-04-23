extends Node
# Parametric AI Director — ADR-004
# Modulates encounter intensity: anti-stall, micro-variance, no runtime ML.

signal intensity_changed(level: float)

# Intensity: 0.0 (calm) → 1.0 (max pressure)
var intensity       : float = 0.3
var stall_timer     : float = 0.0
var kill_streak     : int   = 0
var last_kill_time  : float = 0.0

const STALL_THRESHOLD     := 15.0   # seconds without player progress → boost
const KILL_STREAK_WINDOW  := 5.0    # seconds for streak to count
const INTENSITY_DECAY     := 0.02   # per second when player doing well
const INTENSITY_RAMP      := 0.05   # per second when stalling
const DEATH_PENALTY       := 0.25   # intensity drop on player death (breather)
const INTENSITY_CLAMP_MIN := 0.1
const INTENSITY_CLAMP_MAX := 1.0

# Spawn budget per intensity band
const SPAWN_WEIGHTS := {
	"zombie":       [1.0, 0.8, 0.6, 0.4],  # [low, mid-low, mid-high, high]
	"crow":         [0.2, 0.4, 0.6, 0.8],
	"demon_knight": [0.0, 0.2, 0.4, 0.7],
	"red_arremer":  [0.0, 0.0, 0.2, 0.6],
}

var _time : float = 0.0
var _player_last_x : float = 0.0

func _ready() -> void:
	GameManager.player_respawning.connect(_on_player_died)

func _process(delta: float) -> void:
	_time += delta
	_tick_stall(delta)
	_decay_intensity(delta)

func _tick_stall(delta: float) -> void:
	if not is_instance_valid(GameManager.player):
		return
	var px := GameManager.player.global_position.x
	if abs(px - _player_last_x) < 4.0:
		stall_timer += delta
	else:
		stall_timer    = 0.0
		_player_last_x = px

	if stall_timer >= STALL_THRESHOLD:
		_push_intensity(INTENSITY_RAMP * delta * 3.0)

func _decay_intensity(delta: float) -> void:
	# Ease off when player progresses
	if kill_streak > 2:
		_push_intensity(-INTENSITY_DECAY * delta * 2.0)
	else:
		_push_intensity(-INTENSITY_DECAY * delta * 0.5)

func on_enemy_killed(enemy: Node) -> void:
	var now := _time
	if now - last_kill_time <= KILL_STREAK_WINDOW:
		kill_streak += 1
	else:
		kill_streak = 1
	last_kill_time = now
	# Micro-variance: brief spike then decay handles streaks
	_push_intensity(0.03 * (1.0 / float(max(kill_streak, 1))))

func _on_player_died() -> void:
	kill_streak = 0
	_push_intensity(-DEATH_PENALTY)

func _push_intensity(delta_i: float) -> void:
	intensity = clampf(intensity + delta_i, INTENSITY_CLAMP_MIN, INTENSITY_CLAMP_MAX)
	intensity_changed.emit(intensity)

func get_intensity_band() -> int:
	if intensity < 0.25: return 0
	if intensity < 0.5:  return 1
	if intensity < 0.75: return 2
	return 3

func get_spawn_weight(enemy_type: String) -> float:
	if not SPAWN_WEIGHTS.has(enemy_type):
		return 0.0
	return SPAWN_WEIGHTS[enemy_type][get_intensity_band()]

func pick_enemy_type() -> String:
	var band  := get_intensity_band()
	var total := 0.0
	var types : Array[String] = []
	for k in SPAWN_WEIGHTS:
		var w : float = SPAWN_WEIGHTS[k][band]
		total += w
		types.append(k)

	var roll := randf() * total
	var acc  := 0.0
	for k in types:
		acc += SPAWN_WEIGHTS[k][band]
		if roll <= acc:
			return k
	return "zombie"
