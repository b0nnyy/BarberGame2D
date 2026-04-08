extends Control
func _on_settings_button_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/ustawienia.tscn")

func _on_start_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_scores_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/scores.tscn")
