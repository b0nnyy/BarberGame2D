extends Node

func _ready():

	print("Wybrana postać to: " + GameData.wybrana_postac)

@onready var pause_menu = $UI/PauseMenu
@onready var game_over_menu = $UI/GameOverMenu
@onready var score_label = $UI/GameOverMenu/Panel/VBoxContainer/ScoreLabel
@onready var name_input = $UI/GameOverMenu/Panel/VBoxContainer/NameInput
@onready var save_button = $UI/GameOverMenu/Panel/VBoxContainer/SaveScoreButton
@onready var fade_layer = $UI/FadeLayer
var score_saved := false



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
	score_saved = false

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

	name_input.visible = true
	save_button.visible = true

	name_input.text = ""
	name_input.grab_focus()

	get_tree().paused = true

func _on_restart_button_pressed():

	GameManager.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed():

	get_tree().quit()


func _on_save_score_button_pressed():

	if score_saved:
		return

	score_saved = true

	var player_name = name_input.text.strip_edges()

	if player_name == "":
		player_name = "Anon"

	LeaderboardManager.add_score(
		player_name,
		GameManager.score
	)

	name_input.visible = false
	save_button.visible = false
