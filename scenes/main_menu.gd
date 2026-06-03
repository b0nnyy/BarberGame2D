extends Control

@onready var scores_container = $LeaderboardPanel/MarginContainer/ScoresContainer

const FONT_PRESS_START = preload("res://Art/icons/ikony menu/2/PressStart2P-Regular.ttf")


func _ready():
	show_scores()


func show_scores():

	# usuń stare wpisy
	for child in scores_container.get_children():
		child.queue_free()

	# większy odstęp pionowy między wynikami
	scores_container.add_theme_constant_override("separation", 14)

	# max 10 wyników
	var max_scores = min(10, LeaderboardManager.scores.size())

	for i in range(max_scores):

		var entry = LeaderboardManager.scores[i]

		# ===== WIERSZ (kolumny) =====
		var row = HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER

		# większy odstęp między danymi w jednym wierszu
		row.add_theme_constant_override("separation", 40)

		# większa wysokość wiersza
		row.custom_minimum_size.y = 42

		# ===== RANK =====
		var rank_label = Label.new()
		rank_label.text = str(i + 1) + "."
		rank_label.custom_minimum_size.x = 70
		rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rank_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		# ===== NAME =====
		var name_label = Label.new()
		name_label.text = entry["name"]
		name_label.custom_minimum_size.x = 260
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		# ===== SCORE =====
		var score_label = Label.new()
		score_label.text = str(entry["score"]) + " pkt"
		score_label.custom_minimum_size.x = 170
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		# ===== CZCIONKA DLA CAŁEGO WIERSZA =====
		for label in [rank_label, name_label, score_label]:
			label.add_theme_font_override("font", FONT_PRESS_START)

		# ===== TOP 3 STYLE =====
		if i == 0:
			rank_label.add_theme_color_override("font_color", Color.GOLD)
			name_label.add_theme_color_override("font_color", Color.GOLD)
			score_label.add_theme_color_override("font_color", Color.GOLD)

			rank_label.add_theme_font_size_override("font_size", 26)
			name_label.add_theme_font_size_override("font_size", 26)
			score_label.add_theme_font_size_override("font_size", 26)

		elif i == 1:
			var silver = Color.SILVER

			rank_label.add_theme_color_override("font_color", silver)
			name_label.add_theme_color_override("font_color", silver)
			score_label.add_theme_color_override("font_color", silver)

			rank_label.add_theme_font_size_override("font_size", 24)
			name_label.add_theme_font_size_override("font_size", 24)
			score_label.add_theme_font_size_override("font_size", 24)

		elif i == 2:
			var bronze = Color(0.8, 0.5, 0.2)

			rank_label.add_theme_color_override("font_color", bronze)
			name_label.add_theme_color_override("font_color", bronze)
			score_label.add_theme_color_override("font_color", bronze)

			rank_label.add_theme_font_size_override("font_size", 22)
			name_label.add_theme_font_size_override("font_size", 22)
			score_label.add_theme_font_size_override("font_size", 22)

		else:
			rank_label.add_theme_color_override("font_color", Color.WHITE)
			name_label.add_theme_color_override("font_color", Color.WHITE)
			score_label.add_theme_color_override("font_color", Color.WHITE)

			rank_label.add_theme_font_size_override("font_size", 20)
			name_label.add_theme_font_size_override("font_size", 20)
			score_label.add_theme_font_size_override("font_size", 20)

		# ===== DODANIE DO WIERSZA =====
		row.add_child(rank_label)
		row.add_child(name_label)
		row.add_child(score_label)

		# ===== DODANIE DO LISTY =====
		scores_container.add_child(row)


func _on_settings_button_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/ustawienia.tscn")


func _on_start_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")


func _on_scores_pressed():

	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	# pokaz/ukryj tabelę wyników
	$LeaderboardPanel.visible = !$LeaderboardPanel.visible

func _on_exit_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().quit()

func _on_credits_button_pressed():

	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	get_tree().change_scene_to_file("res://levels/credits.tscn")


func _on_close_button_pressed():

	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	$CreditsPanel.visible = false

func _on_res_1280_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	DisplayServer.window_set_size(Vector2i(1280, 720))
	_center_window()

func _on_res_1600_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	DisplayServer.window_set_size(Vector2i(1600, 900))
	_center_window()

func _on_res_1920_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	_center_window()

func _on_fullscreen_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
		_center_window()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_settings_close_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	$SettingsPanel.visible = false

func _center_window():
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)
