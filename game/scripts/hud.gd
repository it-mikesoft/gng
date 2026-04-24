extends CanvasLayer

@onready var lives_label     : Label     = $LivesLabel
@onready var score_label     : Label     = $ScoreLabel
@onready var game_over_panel : Panel     = $GameOverPanel
@onready var win_panel       : Panel     = $WinPanel
@onready var boss_bar_panel  : Panel     = $BossBarPanel
@onready var boss_bar        : ProgressBar = $BossBarPanel/BossBar
@onready var boss_label      : Label     = $BossBarPanel/BossLabel

func _ready() -> void:
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	GameManager.boss_hp_changed.connect(_on_boss_hp_changed)
	game_over_panel.hide()
	win_panel.hide()
	boss_bar_panel.hide()
	_on_lives_changed(GameManager.lives)
	_on_score_changed(GameManager.score)

func _on_lives_changed(count: int) -> void:
	lives_label.text = "LIVES x" + str(count)

func _on_score_changed(s: int) -> void:
	score_label.text = str(s).lpad(6, "0")

func _on_boss_hp_changed(current: int, maximum: int) -> void:
	if current <= 0:
		boss_bar_panel.hide()
		return
	boss_bar_panel.show()
	boss_bar.max_value = maximum
	boss_bar.value     = current

func _on_game_over() -> void:
	boss_bar_panel.hide()
	game_over_panel.show()

func _on_game_won() -> void:
	boss_bar_panel.hide()
	win_panel.show()
