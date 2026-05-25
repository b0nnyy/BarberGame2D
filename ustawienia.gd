extends Control

# przyciski
@onready var muzyka_button = $VBoxContainer/MusicRow/Muzyka
@onready var dzwieki_button = $VBoxContainer/SfxRow/Dzwieki

# ikonki ON/OFF
@onready var muzyka_icon = $VBoxContainer/MusicRow/MuzykaIcon
@onready var dzwieki_icon = $VBoxContainer/SfxRow/DzwiekiIcon



func _ready():
	_update_icons()

	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus, not GameSettings.music_enabled)

	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus, not GameSettings.sfx_enabled)

	if not muzyka_button.pressed.is_connected(_on_Muzyka_pressed):
		muzyka_button.pressed.connect(_on_Muzyka_pressed)

	if not dzwieki_button.pressed.is_connected(_on_Dzwieki_pressed):
		dzwieki_button.pressed.connect(_on_Dzwieki_pressed)


# kliknięcie MUZYKA
func _on_Muzyka_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	GameSettings.music_enabled = !GameSettings.music_enabled

	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, not GameSettings.music_enabled)

	_update_icons()

	print("Muzyka:", GameSettings.music_enabled)


# kliknięcie DŹWIĘKI
func _on_Dzwieki_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	GameSettings.sfx_enabled = !GameSettings.sfx_enabled

	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, not GameSettings.sfx_enabled)

	_update_icons()

	print("SFX:", GameSettings.sfx_enabled)


# zmiana ikon ON/OFF
func _update_icons():

	if GameSettings.music_enabled:
		muzyka_icon.texture = preload("res://Art/icons/ikony menu/MUSICON.png")
	else:
		muzyka_icon.texture = preload("res://Art/icons/ikony menu/MUSICOFF.png")

	if GameSettings.sfx_enabled:
		dzwieki_icon.texture = preload("res://Art/icons/ikony menu/SOUNDON.png")
	else:
		dzwieki_icon.texture = preload("res://Art/icons/ikony menu/SOUNDOFF.png")


# POWRÓT DO MENU
func _on_Powrot_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
