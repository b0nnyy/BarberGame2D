extends Control

@onready var preview_sprite = $Preview/AnimatedSprite2D

var wybrana_postac = ""
var characters = {
	"Lukasz": preload("res://Characters/Lukasz_frames.tres"),
	"Patryk": preload("res://Characters/Patryk_frames.tres"),
	"Shimmy": preload("res://Characters/Shimmy_frames.tres"),
	"Igor": preload("res://Characters/Igor_frames.tres"),
	"LukaszB": preload("res://Characters/LukaszB_frames.tres")
}



func _on_Patryk_pressed():
	wybrana_postac = "Patryk"
	update_preview("Patryk")
	print("Wybrano Patryka")

func _on_Shimmy_pressed():
	wybrana_postac = "Shimmy"
	update_preview("Shimmy")
	print("Wybrano Shimmyego")
	
func _on_Igor_pressed():
	wybrana_postac = "Igor"
	update_preview("Igor")
	print("Wybrano Igora")


func _on_start_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	if wybrana_postac != "":

		print("Start gry z postacią: " + wybrana_postac)

		GameData.wybrana_postac = wybrana_postac

		get_tree().change_scene_to_file("res://Levels/d_level_salon_01.tscn")

	else:

		print("Najpierw wybierz postać!")




func update_preview(char_name: String):
	if not characters.has(char_name):
		return
	
	preview_sprite.sprite_frames = characters[char_name]
	preview_sprite.play("idle_down") 
	preview_sprite.scale = Vector2(3, 3)




func _on_lukasz_pressed() -> void:
	wybrana_postac = "Lukasz"
	update_preview("Lukasz")
	print("Wybrano Lukasza")


func _on_lukasz_b_pressed() -> void:
	wybrana_postac = "LukaszB"
	update_preview("LukaszB")
	print("Wybrano LukaszaB")
