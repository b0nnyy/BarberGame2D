extends Node

@onready var leaderboard_panel = $UI/GameOverMenu/LeaderboardPanel
@onready var scores_container = $UI/GameOverMenu/LeaderboardPanel/MarginContainer/ScoresContainer
@onready var pause_menu = $UI/PauseMenu
@onready var settings_menu = $UI/SettingsMenu
@onready var game_over_menu = $UI/GameOverMenu
@onready var score_label = $UI/GameOverMenu/Panel/VBoxContainer/ScoreLabel
@onready var name_input = $UI/GameOverMenu/Panel/VBoxContainer/NameInput
@onready var save_button = $UI/GameOverMenu/Panel/VBoxContainer/SaveScoreButton
@onready var fade_layer = $UI/FadeLayer
var score_saved := false

func _ready():
	print("Wybrana postać to: " + GameData.wybrana_postac)
	pause_menu.resume_pressed.connect(_resume_game)
	pause_menu.settings_pressed.connect(_open_settings)
	pause_menu.back_pressed.connect(_close_settings)





func _unhandled_input(event):

	if not event.is_action_pressed("ui_cancel"):
		return

	if settings_menu.visible:
		_close_settings()
		return

	if pause_menu.visible:
		_resume_game()
		return

	_open_pause()


func _open_pause():
	get_tree().paused = true
	pause_menu.visible = true
	settings_menu.visible = false



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
	show_leaderboard()
	leaderboard_panel.visible = true

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

func _open_settings():
	pause_menu.visible = false
	settings_menu.visible = true


func _close_settings():
	settings_menu.visible = false
	pause_menu.visible = true

func _resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	settings_menu.visible = false

func _on_back_button_pressed():
	_close_settings()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

func show_leaderboard():

	for child in scores_container.get_children():
		child.queue_free()

	var max_scores = min(10, LeaderboardManager.scores.size())

	for i in range(max_scores):

		var entry = LeaderboardManager.scores[i]

		var label = Label.new()
		label.text = str(i + 1) + ". " + entry["name"] + " - " + str(entry["score"]) + " pkt"

		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# TOP 3
		if i == 0:
			label.add_theme_color_override("font_color", Color.GOLD)
		elif i == 1:
			label.add_theme_color_override("font_color", Color.SILVER)
		elif i == 2:
			label.add_theme_color_override("font_color", Color(0.8, 0.5, 0.2))

		scores_container.add_child(label)
