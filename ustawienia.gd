extends Control

signal back_pressed

# przyciski
@onready var muzyka_button = $VBoxContainer/MusicRow/Muzyka
@onready var dzwieki_button = $VBoxContainer/SfxRow/Dzwieki

# ikonki ON/OFF
@onready var muzyka_icon = $VBoxContainer/MusicRow/MuzykaIcon
@onready var dzwieki_icon = $VBoxContainer/SfxRow/DzwiekiIcon


func _ready():
	# Działa i w menu głównym, i podczas pauzy w grze
	process_mode = Node.PROCESS_MODE_ALWAYS

	_update_icons()

	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus, not GameSettings.music_enabled)

	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus, not GameSettings.sfx_enabled)

	if not muzyka_button.pressed.is_connected(_on_Muzyka_pressed):
		muzyka_button.pressed.connect(_on_Muzyka_pressed)

	if not dzwieki_button.pressed.is_connected(_on_Dzwieki_pressed):
		dzwieki_button.pressed.connect(_on_Dzwieki_pressed)


func _input(event):

	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		AudioManager.play_sfx("res://sounds/buttonpress.wav")

		if get_tree().paused:
			back_pressed.emit()
		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

		accept_event()


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


# POWRÓT
func _on_Powrot_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	if get_tree().paused:
		back_pressed.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")



func _on_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1280, 720))
	_center_window()


func _on_button_3_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	_center_window()


func _on_button_2_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1600, 900))
	_center_window()


func _on_button_4_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
		_center_window()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _center_window():
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()

	DisplayServer.window_set_position(
		Vector2i(
			int((screen_size.x - window_size.x) * 0.5),
			int((screen_size.y - window_size.y) * 0.5)
		)
	)
