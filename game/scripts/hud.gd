extends CanvasLayer

@onready var lives_label    : Label = $LivesLabel
@onready var game_over_panel: Panel = $GameOverPanel

func _ready() -> void:
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.game_over.connect(_on_game_over)
	game_over_panel.hide()
	_on_lives_changed(GameManager.lives)

func _on_lives_changed(count: int) -> void:
	lives_label.text = "LIVES x" + str(count)

func _on_game_over() -> void:
	game_over_panel.show()
