extends Control

signal resume_pressed
signal settings_pressed
signal back_pressed

@onready var fade_layer = $"../FadeLayer"

var is_exiting := false


func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _input(event):

	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		resume_pressed.emit()
		get_viewport().set_input_as_handled()


func _on_Kontynuuj_pressed():

	resume_pressed.emit()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")


func _on_Ustawienia_pressed():

	settings_pressed.emit()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")


func _on_Wyjdz_pressed():

	if is_exiting:
		return

	is_exiting = true

	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	fade_layer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	fade_layer.visible = true
	fade_layer.color.a = 0.0

	var t = create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(fade_layer, "color:a", 1.0, 0.6)

	await t.finished

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
