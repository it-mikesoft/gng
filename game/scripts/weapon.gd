extends Area2D

const SPEED      := 200.0
const LIFETIME   := 2.0

var direction    := 1
var _time        := 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var cs : CollisionShape2D = get_node_or_null("CollisionShape2D")
	if cs and cs.shape == null:
		var s := RectangleShape2D.new()
		s.size = Vector2(8, 4)
		cs.shape = s
	var sp : Sprite2D = get_node_or_null("Sprite2D")
	if sp and ResourceLoader.exists("res://assets/sprites/weapons/lance.png"):
		sp.texture = load("res://assets/sprites/weapons/lance.png")

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
