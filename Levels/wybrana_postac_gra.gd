extends Node

func _ready():

	print("Wybrana postać to: " + GameData.wybrana_postac)

@onready var pause_menu = $UI/PauseMenu
@onready var game_over_menu = $UI/GameOverMenu
@onready var score_label = $UI/GameOverMenu/Panel/VBoxContainer/ScoreLabel
@onready var fade_layer = $UI/FadeLayer


func _input(event):

	if event.is_action_pressed("ui_cancel"):

		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()


func _pause_game():

	get_tree().paused = true
	
	pause_menu.visible = true


func _resume_game():

	get_tree().paused = false
	pause_menu.visible = false

func show_game_over(score):

	score_label.text = "Wynik: " + str(score)

	var t = create_tween()

	t.tween_property(
		fade_layer,
		"color:a",
		1.0,
		1.0
	)

	await t.finished

	game_over_menu.visible = true

	get_tree().paused = true

func _on_restart_button_pressed():

	GameManager.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed():

	get_tree().quit()
