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
var last_score := 0
var last_player_name := ""
var last_player_rank := -1


func _ready():
	fade_layer.color.a = 0.0
	print("Wybrana postać to: " + GameData.wybrana_postac)

	pause_menu.resume_pressed.connect(_resume_game)
	pause_menu.settings_pressed.connect(_open_settings)
	pause_menu.back_pressed.connect(_close_settings)
	settings_menu.back_pressed.connect(_close_settings)

	# UI ma działać podczas pauzy
	game_over_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	settings_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	name_input.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	save_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# ENTER podczas wpisywania nicku
	name_input.gui_input.connect(_on_name_input_gui_input)


func _unhandled_input(event):

	# Jeśli jest game over, nie pozwalamy odpalać pauzy ESC-em
	if game_over_menu.visible:
		return

	# ===== PAUSE =====
	if event.is_action_pressed("ui_cancel"):

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


# ================= GAME OVER =================

func show_game_over(score):

	last_score = score
	score_saved = false
	last_player_name = ""
	last_player_rank = -1

	score_label.text = "Wynik: " + str(score)

	game_over_menu.visible = true
	leaderboard_panel.visible = true

	name_input.visible = true
	save_button.visible = true

	name_input.text = ""
	name_input.grab_focus()

	show_leaderboard()

	# FADE
	fade_layer.color.a = 0.0
	fade_layer.visible = true

	var t = create_tween()
	t.tween_property(fade_layer, "color:a", 1.0, 1.0)

	await t.finished

	get_tree().paused = true


func _on_name_input_gui_input(event):

	if not game_over_menu.visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			name_input.accept_event()
			_on_save_score_button_pressed()


func _on_save_score_button_pressed():

	if score_saved:
		return

	score_saved = true

	var player_name = name_input.text.strip_edges()

	if player_name == "":
		player_name = "Anon"

	last_player_name = player_name

	LeaderboardManager.add_score(player_name, last_score)

	last_player_rank = _find_player_rank(player_name, last_score)

	name_input.visible = false
	save_button.visible = false

	show_leaderboard()
	leaderboard_panel.visible = true


func _find_player_rank(player_name: String, player_score: int) -> int:

	for i in range(LeaderboardManager.scores.size()):

		var entry = LeaderboardManager.scores[i]

		if entry["name"] == player_name and entry["score"] == player_score:
			return i + 1

	return -1


# ================= ANIMACJA TABELI =================

func animate_leaderboard_row(row: Control, delay: float):

	row.modulate.a = 0.0
	row.scale = Vector2(0.92, 0.92)

	var t = create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)

	t.tween_interval(delay)
	t.tween_property(row, "modulate:a", 1.0, 0.25)
	t.parallel().tween_property(row, "scale", Vector2.ONE, 0.25)


# ================= PAUSE =================

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


# ================= RESTART / EXIT =================

func _on_restart_button_pressed():
	GameManager.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_button_pressed():
	get_tree().quit()


# ================= LEADERBOARD =================

func show_leaderboard():

	for child in scores_container.get_children():
		child.queue_free()

	var scores = LeaderboardManager.scores
	var max_scores = min(10, scores.size())

	var delay := 0.0

	# ===== TOP 10 =====
	for i in range(max_scores):

		var entry = scores[i]

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 40)

		var rank = Label.new()
		rank.text = str(i + 1) + "."
		rank.custom_minimum_size.x = 60
		rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var player_name_label = Label.new()
		player_name_label.text = entry["name"]
		player_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var score_value_label = Label.new()
		score_value_label.text = str(entry["score"]) + " pkt"
		score_value_label.custom_minimum_size.x = 140
		score_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		for l in [rank, player_name_label, score_value_label]:
			l.add_theme_font_size_override("font_size", 26)

		# ===== TOP 3 KOLORY =====
		if i == 0:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.GOLD)

		elif i == 1:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.SILVER)

		elif i == 2:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color(0.8, 0.5, 0.2))

		# ===== PODŚWIETLENIE TWOJEGO WYNIKU, JEŚLI JEST W TOP 10 =====
		if score_saved and i + 1 == last_player_rank:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.CYAN)
				l.add_theme_font_size_override("font_size", 30)

		row.add_child(rank)
		row.add_child(player_name_label)
		row.add_child(score_value_label)

		scores_container.add_child(row)

		animate_leaderboard_row(row, delay)
		delay += 0.08


	# ===== JEŚLI GRACZ JEST POZA TOP 10, POKAŻ "..." I JEGO MIEJSCE =====
	if score_saved and last_player_rank > 10:

		var dots = Label.new()
		dots.text = "..."
		dots.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dots.add_theme_font_size_override("font_size", 32)
		dots.add_theme_color_override("font_color", Color.WHITE)

		scores_container.add_child(dots)

		animate_leaderboard_row(dots, delay)
		delay += 0.08


		var player_row = HBoxContainer.new()
		player_row.add_theme_constant_override("separation", 40)

		var rank = Label.new()
		rank.text = str(last_player_rank) + "."
		rank.custom_minimum_size.x = 60
		rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var player_name_label = Label.new()
		player_name_label.text = last_player_name
		player_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var score_value_label = Label.new()
		score_value_label.text = str(last_score) + " pkt"
		score_value_label.custom_minimum_size.x = 140
		score_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		for l in [rank, player_name_label, score_value_label]:
			l.add_theme_font_size_override("font_size", 30)
			l.add_theme_color_override("font_color", Color.CYAN)

		player_row.add_child(rank)
		player_row.add_child(player_name_label)
		player_row.add_child(score_value_label)

		scores_container.add_child(player_row)

		animate_leaderboard_row(player_row, delay)
