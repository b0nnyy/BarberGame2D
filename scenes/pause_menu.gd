extends Control

signal resume_pressed
signal settings_pressed
signal back_pressed


func _ready():
	visible = false



func _on_Kontynuuj_pressed():

	resume_pressed.emit()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

func _on_Ustawienia_pressed():

	settings_pressed.emit()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
func _on_Wyjdz_pressed():

	back_pressed.emit()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
