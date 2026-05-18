extends Control

@onready var preview_sprite = $Preview/AnimatedSprite2D

var wybrana_postac = ""

var characters = {
	"Lukasz": preload("res://Characters/lukasz_frames.tres"),
	"Patryk": preload("res://Characters/Patryk_frames.tres"),
	"Shimmy": preload("res://Characters/Shimmy_frames.tres"),
	"Igor": preload("res://Characters/Igor_frames.tres"),
	"LukaszB": preload("res://Characters/LukaszB_frames.tres")
}

func _ready():
	preview_sprite.visible = false

	$VBoxContainer/LukaszB.pressed.connect(func(): select_character("LukaszB"))
	$VBoxContainer/Patryk.pressed.connect(func(): select_character("Patryk"))
	$VBoxContainer/Shimmy.pressed.connect(func(): select_character("Shimmy"))
	$VBoxContainer/Igor.pressed.connect(func(): select_character("Igor"))
	$VBoxContainer/Lukasz.pressed.connect(func(): select_character("Lukasz"))


func select_character(char_name: String):
	if not characters.has(char_name):
		print("Brak postaci: ", char_name)
		return

	wybrana_postac = char_name

	preview_sprite.visible = true
	preview_sprite.sprite_frames = characters[char_name]
	preview_sprite.play("idle_down")
	preview_sprite.scale = Vector2(3, 3)

	print("Wybrano postać: ", wybrana_postac)


func _on_LukaszB_pressed():
	select_character("LukaszB")

func _on_lukasz_b_pressed():
	select_character("LukaszB")

func _on_Patryk_pressed():
	select_character("Patryk")

func _on_patryk_pressed():
	select_character("Patryk")

func _on_Shimmy_pressed():
	select_character("Shimmy")

func _on_shimmy_pressed():
	select_character("Shimmy")

func _on_Igor_pressed():
	select_character("Igor")

func _on_igor_pressed():
	select_character("Igor")

func _on_Lukasz_pressed():
	select_character("Lukasz")

func _on_lukasz_pressed():
	select_character("Lukasz")


func _on_start_pressed():
	AudioManager.play_sfx("res://sounds/buttonpress.wav")

	if wybrana_postac == "":
		print("Najpierw wybierz postać!")
		return

	GameData.wybrana_postac = wybrana_postac
	print("Start gry z postacią: ", wybrana_postac)

	get_tree().change_scene_to_file("res://Levels/d_level_salon_01.tscn")
