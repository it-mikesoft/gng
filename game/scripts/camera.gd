extends Camera2D

@export var target         : NodePath
@export var smoothing_spd  : float = 6.0

var _target_node : Node2D

func _ready() -> void:
	if target:
		_target_node = get_node(target)
	else:
		_target_node = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_target_node):
		_target_node = get_tree().get_first_node_in_group("player")
		if is_instance_valid(_target_node):
			global_position = _target_node.global_position
		return
	global_position = global_position.lerp(
		_target_node.global_position,
		clampf(smoothing_spd * delta, 0.0, 1.0)
	)
