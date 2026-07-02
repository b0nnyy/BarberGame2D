extends Node

@onready var sfx_player = $SFXPlayer
@onready var music_player = $MusicPlayer
@onready var sfx_players = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3,
	$SFXPlayer4
]

var sfx_index := 0

var current_music_path: String = ""


func play_sfx(file_path: String, pitch: float = 1.0) -> void:
	var sfx = load(file_path) as AudioStream
	if sfx == null:
		return

	var player = sfx_players[sfx_index]

	sfx_index = (sfx_index + 1) % sfx_players.size()

	player.stream = sfx
	player.pitch_scale = pitch
	player.play()


func play_music(file_path: String) -> void:
	if current_music_path == file_path and music_player.playing:
		return

	var music = load(file_path) as AudioStream
	if music == null:
		return

	current_music_path = file_path
	music_player.stream = music
	music_player.play()


func stop_music():
	
	music_player.stop()
	current_music_path = ""

func play_sfx_pitch(file_path: String, pitch: float) -> void:
	var sfx = load(file_path) as AudioStream
	if sfx == null:
		return

	sfx_player.stream = sfx
	sfx_player.pitch_scale = pitch
	sfx_player.play()
