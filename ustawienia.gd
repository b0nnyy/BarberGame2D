extends Control

signal back_pressed

# =========================
# UI REFERENCES
# =========================

@onready var muzyka_button = $VBoxContainer/MusicRow/Muzyka
@onready var dzwieki_button = $VBoxContainer/SfxRow/Dzwieki

@onready var muzyka_icon = $VBoxContainer/MusicRow/MuzykaIcon
@onready var dzwieki_icon = $VBoxContainer/SfxRow/DzwiekiIcon

@onready var music_row = $VBoxContainer/MusicRow
@onready var sfx_row = $VBoxContainer/SfxRow

@onready var res_button = $VBoxContainer/resolution
@onready var powrot_button = $VBoxContainer/Powrot

@onready var button1 = $VBoxContainer/Button
@onready var button2 = $VBoxContainer/Button2
@onready var button3 = $VBoxContainer/Button3
@onready var button4 = $VBoxContainer/Button4

@onready var vbox = $VBoxContainer


# =========================
# STATE
# =========================

var is_alt_menu := false


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	_update_icons()
	_apply_audio_settings()

	_set_alt_menu(false)

	res_button.pressed.connect(_on_res_pressed)

	if not muzyka_button.pressed.is_connected(_on_Muzyka_pressed):
		muzyka_button.pressed.connect(_on_Muzyka_pressed)

	if not dzwieki_button.pressed.is_connected(_on_Dzwieki_pressed):
		dzwieki_button.pressed.connect(_on_Dzwieki_pressed)


# =========================
# RESOLUTION MENU TOGGLE
# =========================

func _on_res_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	is_alt_menu = true
	_set_alt_menu(true)


func _set_alt_menu(state: bool):

	# audio menu
	music_row.visible = !state
	sfx_row.visible = !state

	# main resolution button
	res_button.visible = !state

	# resolution buttons
	button1.visible = state
	button2.visible = state
	button3.visible = state
	button4.visible = state

	# exit button always visible
	powrot_button.visible = true


# =========================
# AUDIO
# =========================

func _apply_audio_settings():
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus, not GameSettings.music_enabled)

	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus, not GameSettings.sfx_enabled)


func _on_Muzyka_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	GameSettings.music_enabled = !GameSettings.music_enabled
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, not GameSettings.music_enabled)

	_update_icons()


func _on_Dzwieki_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	GameSettings.sfx_enabled = !GameSettings.sfx_enabled
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, not GameSettings.sfx_enabled)

	_update_icons()


func _update_icons():
	if GameSettings.music_enabled:
		muzyka_icon.texture = preload("res://Art/icons/ikony menu/MUSICON.png")
	else:
		muzyka_icon.texture = preload("res://Art/icons/ikony menu/MUSICOFF.png")

	if GameSettings.sfx_enabled:
		dzwieki_icon.texture = preload("res://Art/icons/ikony menu/SOUNDON.png")
	else:
		dzwieki_icon.texture = preload("res://Art/icons/ikony menu/SOUNDOFF.png")


# =========================
# INPUT
# =========================

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

func _on_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1280, 720))
	_center_window()


func _on_button_2_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1600, 900))
	_center_window()


func _on_button_3_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	_center_window()


func _on_button_4_pressed():
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

# =========================
# EXIT BUTTON
# =========================

func _on_Powrot_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	if get_tree().paused:
		back_pressed.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
