extends Node

var _sfx_bus  : int = AudioServer.get_bus_index("Master")
var _music_player : AudioStreamPlayer
var _current_music: String = ""

const SFX := {
	"jump":         "res://assets/audio/sfx/jump.wav",
	"land":         "res://assets/audio/sfx/land.wav",
	"attack":       "res://assets/audio/sfx/attack.wav",
	"player_hit":   "res://assets/audio/sfx/player_hit.wav",
	"player_death": "res://assets/audio/sfx/player_death.wav",
	"enemy_die":    "res://assets/audio/sfx/enemy_die.wav",
	"boss_hit":     "res://assets/audio/sfx/boss_hit.wav",
	"checkpoint":   "res://assets/audio/sfx/checkpoint.wav",
	"game_over":    "res://assets/audio/sfx/game_over.wav",
	"win":          "res://assets/audio/sfx/win.wav",
}

const MUSIC := {
	"level": "res://assets/audio/music/level_music.wav",
	"boss":  "res://assets/audio/music/boss_music.wav",
}

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus         = "Master"
	_music_player.volume_db   = -8.0
	_music_player.finished.connect(_on_music_finished)
	add_child(_music_player)

func play_sfx(name: String, vol_db: float = 0.0) -> void:
	if not SFX.has(name):
		return
	var path : String = SFX[name]
	if not ResourceLoader.exists(path):
		return
	var stream = ResourceLoader.load(path, "AudioStream")
	if stream == null:
		return
	var p := AudioStreamPlayer.new()
	p.stream    = stream
	p.volume_db = vol_db
	p.bus       = "Master"
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func play_music(name: String) -> void:
	if _current_music == name:
		return
	if not MUSIC.has(name):
		return
	var path : String = MUSIC[name]
	if not ResourceLoader.exists(path):
		return
	var stream = ResourceLoader.load(path, "AudioStream")
	if stream == null:
		return
	_current_music       = name
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_current_music = ""
	_music_player.stop()

func _on_music_finished() -> void:
	if _current_music != "":
		_music_player.play()  # loop
