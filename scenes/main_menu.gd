extends Control

@onready var scores_container = $LeaderboardPanel/MarginContainer/ScoresContainer


func _ready():
	show_scores()


func show_scores():

	# usuń stare wpisy
	for child in scores_container.get_children():
		child.queue_free()

	# max 10 wyników
	var max_scores = min(10, LeaderboardManager.scores.size())

	for i in range(max_scores):

		var entry = LeaderboardManager.scores[i]

		# ===== WIERSZ (kolumny) =====
		var row = HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 25)

		# ===== RANK =====
		var rank_label = Label.new()
		rank_label.text = str(i + 1) + "."
		rank_label.custom_minimum_size.x = 50
		rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# ===== NAME =====
		var name_label = Label.new()
		name_label.text = entry["name"]
		name_label.custom_minimum_size.x = 200
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# ===== SCORE =====
		var score_label = Label.new()
		score_label.text = str(entry["score"]) + " pkt"
		score_label.custom_minimum_size.x = 120
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# ===== TOP 3 STYLE =====
		if i == 0:
			rank_label.add_theme_color_override("font_color", Color.GOLD)
			name_label.add_theme_color_override("font_color", Color.GOLD)
			score_label.add_theme_color_override("font_color", Color.GOLD)

			rank_label.add_theme_font_size_override("font_size", 30)
			name_label.add_theme_font_size_override("font_size", 30)
			score_label.add_theme_font_size_override("font_size", 30)

		elif i == 1:
			var silver = Color.SILVER

			rank_label.add_theme_color_override("font_color", silver)
			name_label.add_theme_color_override("font_color", silver)
			score_label.add_theme_color_override("font_color", silver)

			rank_label.add_theme_font_size_override("font_size", 28)
			name_label.add_theme_font_size_override("font_size", 28)
			score_label.add_theme_font_size_override("font_size", 28)

		elif i == 2:
			var bronze = Color(0.8, 0.5, 0.2)

			rank_label.add_theme_color_override("font_color", bronze)
			name_label.add_theme_color_override("font_color", bronze)
			score_label.add_theme_color_override("font_color", bronze)

			rank_label.add_theme_font_size_override("font_size", 26)
			name_label.add_theme_font_size_override("font_size", 26)
			score_label.add_theme_font_size_override("font_size", 26)

		else:
			rank_label.add_theme_font_size_override("font_size", 22)
			name_label.add_theme_font_size_override("font_size", 22)
			score_label.add_theme_font_size_override("font_size", 22)

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
