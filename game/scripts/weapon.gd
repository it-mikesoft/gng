extends Area2D

const SPEED      := 200.0
const LIFETIME   := 2.0

var direction    := 1
var _time        := 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func set_direction(dir: int) -> void:
	direction     = dir
	scale.x       = float(dir)   # flip sprite with direction

func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta
	_time      += delta
	if _time >= LIFETIME:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(-direction)
	queue_free()
