extends Node

@onready var container = $VBoxContainer


func _ready():

	# bardzo ważne — naprawia problem z niedziałającym Back
	get_tree().paused = false

	show_scores()


func show_scores():

	# usuń stare wpisy
	for child in container.get_children():
		child.queue_free()

	# TOP 10 maksymalnie
	var max_scores = min(10, LeaderboardManager.scores.size())

	for i in range(max_scores):

		var entry = LeaderboardManager.scores[i]

		var label = Label.new()

		# tekst z numeracją
		label.text = str(i + 1) + ". " + entry["name"] + " — " + str(entry["score"]) + " pkt"

		# wyróżnienie TOP 3
		if i == 0:
			label.add_theme_color_override("font_color", Color(1, 0.84, 0)) # złoty
			label.add_theme_font_size_override("font_size", 28)

		elif i == 1:
			label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75)) # srebrny
			label.add_theme_font_size_override("font_size", 26)

		elif i == 2:
			label.add_theme_color_override("font_color", Color(0.8, 0.5, 0.2)) # brązowy
			label.add_theme_font_size_override("font_size", 24)

		container.add_child(label)


func _on_back_button_pressed():

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
