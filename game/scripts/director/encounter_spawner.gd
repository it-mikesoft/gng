extends Node2D
# Spawns enemies at marked spawn points driven by AiDirector intensity.

@export var spawn_interval_min : float = 3.0
@export var spawn_interval_max : float = 8.0
@export var max_live_enemies   : int   = 6

@export var zombie_scene       : PackedScene
@export var crow_scene         : PackedScene
@export var demon_knight_scene : PackedScene
@export var red_arremer_scene  : PackedScene

@onready var director          : Node       = $AiDirector
@onready var spawn_points      : Array[Node2D]

var _spawn_timer  : float = 0.0
var _next_interval: float = 4.0
var _live_enemies : int   = 0

func _ready() -> void:
	spawn_points = []
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
	_next_interval = _rand_interval()

func _process(delta: float) -> void:
	_spawn_timer += delta
	if _spawn_timer >= _next_interval and _live_enemies < max_live_enemies:
		_spawn_timer   = 0.0
		_next_interval = _rand_interval()
		_try_spawn()

func _try_spawn() -> void:
	if spawn_points.is_empty():
		return
	var sp   : Node2D = spawn_points[randi() % spawn_points.size()]
	var type : String = director.pick_enemy_type()
	var scene : PackedScene = _scene_for(type)
	if scene == null:
		return
	var enemy : CharacterBody2D = scene.instantiate() as CharacterBody2D
	get_parent().add_child(enemy)
	enemy.global_position = sp.global_position
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)
	_live_enemies += 1

func _on_enemy_died(enemy: Node) -> void:
	_live_enemies = max(0, _live_enemies - 1)
	director.on_enemy_killed(enemy)

func _rand_interval() -> float:
	var t := lerpf(spawn_interval_max, spawn_interval_min, director.intensity)
	return t + randf_range(-0.5, 0.5)

func _scene_for(type: String) -> PackedScene:
	match type:
		"zombie":       return zombie_scene
		"crow":         return crow_scene
		"demon_knight": return demon_knight_scene
		"red_arremer":  return red_arremer_scene
	return null
