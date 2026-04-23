extends Node2D

const GROUND_Y     := 162.0
const LEVEL_WIDTH  := 1280.0

func _ready() -> void:
	_build_geometry()
	_setup_player()
	_setup_checkpoint()
	GameManager.game_over.connect(_on_game_over)

# ── geometry ──────────────────────────────────────────────────────────────────

func _build_geometry() -> void:
	_setup_ground()
	_add_platform(Vector2(140, 125), Vector2(64,  10))
	_add_platform(Vector2(290, 105), Vector2(64,  10))
	_add_platform(Vector2(440, 130), Vector2(64,  10))
	_add_platform(Vector2(580, 115), Vector2(64,  10))
	_add_platform(Vector2(750, 105), Vector2(80,  10))
	_add_platform(Vector2(940, 130), Vector2(64,  10))
	_add_platform(Vector2(1100, 125), Vector2(64, 10))
	# Ceiling to keep projectiles in
	_add_invisible_wall(Vector2(LEVEL_WIDTH * 0.5, -10), Vector2(LEVEL_WIDTH, 10))
	# Left / right bounds
	_add_invisible_wall(Vector2(-5,  GROUND_Y * 0.5), Vector2(10, GROUND_Y))
	_add_invisible_wall(Vector2(LEVEL_WIDTH + 5, GROUND_Y * 0.5), Vector2(10, GROUND_Y))

func _setup_ground() -> void:
	var ground : StaticBody2D = $Ground
	ground.position = Vector2(LEVEL_WIDTH * 0.5, GROUND_Y)
	var cs : CollisionShape2D = $Ground/GroundShape
	var s  := RectangleShape2D.new()
	s.size  = Vector2(LEVEL_WIDTH, 20)
	cs.shape = s
	# Draw ground
	var draw := _make_draw_node(Vector2(LEVEL_WIDTH * 0.5, GROUND_Y + 5),
		Vector2(LEVEL_WIDTH, 20), Color(0.22, 0.15, 0.08))
	add_child(draw)

func _add_platform(pos: Vector2, size: Vector2) -> void:
	var sb := StaticBody2D.new()
	var cs := CollisionShape2D.new()
	var sh := RectangleShape2D.new()
	sh.size  = size
	cs.shape = sh
	sb.add_child(cs)
	sb.position = pos
	add_child(sb)
	var draw := _make_draw_node(pos, size, Color(0.22, 0.15, 0.08))
	add_child(draw)

func _add_invisible_wall(pos: Vector2, size: Vector2) -> void:
	var sb := StaticBody2D.new()
	var cs := CollisionShape2D.new()
	var sh := RectangleShape2D.new()
	sh.size  = size
	cs.shape = sh
	sb.add_child(cs)
	sb.position = pos
	add_child(sb)

func _make_draw_node(pos: Vector2, size: Vector2, col: Color) -> Node2D:
	var n := Node2D.new()
	n.position = pos
	# Capture by value for the lambda
	var s := size
	var c := col
	n.draw.connect(func(): n.draw_rect(Rect2(-s * 0.5, s), c, true))
	n.queue_redraw()
	return n

# ── player ────────────────────────────────────────────────────────────────────

func _setup_player() -> void:
	var player : CharacterBody2D = $Player
	var cs : CollisionShape2D = player.get_node("CollisionShape2D")
	if cs.shape == null:
		var s := RectangleShape2D.new()
		s.size = Vector2(12, 22)
		cs.shape = s
	var hb : CollisionShape2D = player.get_node("Hurtbox/CollisionShape2D")
	if hb.shape == null:
		var s := RectangleShape2D.new()
		s.size = Vector2(12, 22)
		hb.shape = s
	if player.weapon_scene == null:
		player.weapon_scene = load("res://scenes/weapons/lance.tscn")
	# Placeholder rect on player
	var ph := _make_draw_node(Vector2.ZERO, Vector2(12, 22), Color(0.9, 0.8, 0.2))
	player.add_child(ph)
	GameManager.set_checkpoint(player.global_position)

func _setup_checkpoint() -> void:
	var cp : Area2D = $Checkpoint
	var cs : CollisionShape2D = $Checkpoint/CheckpointShape
	if cs.shape == null:
		var s := CircleShape2D.new()
		s.radius = 14.0
		cs.shape = s

# ── game over ─────────────────────────────────────────────────────────────────

func _on_game_over() -> void:
	# Any key restarts after 2 seconds
	await get_tree().create_timer(2.0).timeout
	set_process_unhandled_key_input(true)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().reload_current_scene()
