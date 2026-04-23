extends CanvasLayer

@onready var lives_label     : Label = $LivesLabel
@onready var score_label     : Label = $ScoreLabel
@onready var game_over_panel : Panel = $GameOverPanel
@onready var win_panel       : Panel = $WinPanel

func _ready() -> void:
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	game_over_panel.hide()
	win_panel.hide()
	_on_lives_changed(GameManager.lives)
	_on_score_changed(GameManager.score)

func _on_lives_changed(count: int) -> void:
	lives_label.text = "LIVES x" + str(count)

func _on_score_changed(s: int) -> void:
	score_label.text = str(s).lpad(6, "0")

func _on_game_over() -> void:
	game_over_panel.show()

func _on_game_won() -> void:
	win_panel.show()
