extends Control

func _on_Muzyka_toggled(enabled):
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, not enabled)
	print("Muzyka:", enabled)


func _on_Dzwieki_toggled(enabled):
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, not enabled)


func _on_Powrot_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

@onready var muzyka_checkbox = $CenterContainer/VBoxContainer/Muzyka
@onready var dzwieki_checkbox = $CenterContainer/VBoxContainer/Dzwieki

func _ready():
	muzyka_checkbox.button_pressed = true
	dzwieki_checkbox.button_pressed = true
