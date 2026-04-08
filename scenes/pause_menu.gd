extends Control


func _ready():
	visible = false


func _on_Kontynuuj_pressed():

	get_tree().paused = false
	visible = false


func _on_Ustawienia_pressed():

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ustawienia.tscn")

func _on_Wyjdz_pressed():

	get_tree().quit()
