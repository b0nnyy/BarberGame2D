extends Control

var characters = {
	"Dawid": {
		"name_texture": preload("res://Art/menu/DAWID.png"),
		"character_texture": preload("res://Art/menu/DAWID 2.png")
	},
	"Michal": {
		"name_texture": preload("res://Art/menu/MICHAL.png"),
		"character_texture": preload("res://Art/menu/MICHAL 2.png")
	},
	"Wiktoria": {
		"name_texture": preload("res://Art/menu/WIKTORIA.png"),
		"character_texture": preload("res://Art/menu/WIKTORIA 2.png")
	},
	"Radek": {
		"name_texture": preload("res://Art/menu/RADEK.png"),
		"character_texture": preload("res://Art/menu/RADEK 2.png")
	}
}

var character_order = ["Dawid", "Michal", "Wiktoria", "Radek"]

@onready var hbox = $HBoxContainer


func _ready():
	for child in hbox.get_children():
		child.queue_free()

	for char_name in character_order:
		var card = _make_card(char_name)
		hbox.add_child(card)

	hbox.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hbox.offset_top = -800
	hbox.offset_bottom = -500
	hbox.offset_left = 120
	hbox.offset_right = -1380
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER


func _make_card(char_name: String) -> VBoxContainer:

	var card = VBoxContainer.new()
	card.alignment = BoxContainer.ALIGNMENT_CENTER
	card.add_theme_constant_override("separation", 16)
	card.custom_minimum_size = Vector2(180, 280)

	# =========================
	# GRAFIKA POSTACI
	# =========================

	var preview = TextureRect.new()
	preview.texture = characters[char_name]["character_texture"]
	preview.custom_minimum_size = Vector2(170, 210)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

	card.add_child(preview)

	# =========================
	# GRAFIKA IMIENIA
	# =========================

	var name_image = TextureRect.new()
	name_image.texture = characters[char_name]["name_texture"]
	name_image.custom_minimum_size = Vector2(160, 50)
	name_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	name_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	name_image.mouse_filter = Control.MOUSE_FILTER_IGNORE

	card.add_child(name_image)

	return card


func _on_close_button_pressed() -> void:
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
