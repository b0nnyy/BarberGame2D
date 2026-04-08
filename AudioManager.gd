extends Node

@onready var sfx_player = $SFXPlayer
@onready var music_player = $MusicPlayer


func play_sfx(file_path: String) -> void:
	var sfx = load(file_path) as AudioStream
	if sfx:
		sfx_player.stream = sfx
		sfx_player.play()
