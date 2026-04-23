extends Area2D

const SPEED    := 130.0
const LIFETIME := 4.0

var _vel   : Vector2 = Vector2.ZERO
var _time  : float   = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var cs : CollisionShape2D = get_node_or_null("CollisionShape2D")
	if cs and cs.shape == null:
		var s := CircleShape2D.new()
		s.radius = 4.0
		cs.shape = s

func set_velocity_from_angle(angle: float) -> void:
	_vel = Vector2(cos(angle), sin(angle)) * SPEED

func _physics_process(delta: float) -> void:
	position += _vel * delta
	_time    += delta
	if _time >= LIFETIME:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(-int(sign(_vel.x)) if _vel.x != 0 else 1)
	queue_free()
