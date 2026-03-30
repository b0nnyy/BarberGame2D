extends Control

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ustawienia.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_scores_pressed():
	get_tree().change_scene_to_file("res://scenes/scores.tscn")
