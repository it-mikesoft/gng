extends CanvasLayer

@onready var lives_label     : Label     = $LivesLabel
@onready var score_label     : Label     = $ScoreLabel
@onready var game_over_panel : Panel     = $GameOverPanel
@onready var win_panel       : Panel     = $WinPanel
@onready var boss_bar_panel  : Panel     = $BossBarPanel
@onready var boss_bar        : ProgressBar = $BossBarPanel/BossBar
@onready var boss_label      : Label     = $BossBarPanel/BossLabel
@onready var announce_label  : Label     = $AnnounceLabel

func _ready() -> void:
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	GameManager.boss_hp_changed.connect(_on_boss_hp_changed)
	GameManager.boss_phase_changed.connect(_on_boss_phase_changed)
	game_over_panel.hide()
	win_panel.hide()
	boss_bar_panel.hide()
	announce_label.modulate.a = 0.0
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

func _on_boss_phase_changed(phase: int) -> void:
	announce_label.text      = "- PHASE " + str(phase) + " -"
	announce_label.modulate  = Color(1.0, 0.2, 0.2, 1.0)
	var tw := create_tween()
	tw.tween_property(announce_label, "modulate:a", 1.0, 0.1)
	tw.tween_interval(1.5)
	tw.tween_property(announce_label, "modulate:a", 0.0, 0.5)

func _on_game_over() -> void:
	boss_bar_panel.hide()
	game_over_panel.show()

func _on_game_won() -> void:
	boss_bar_panel.hide()
	win_panel.show()
