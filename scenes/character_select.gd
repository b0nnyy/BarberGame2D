extends Control

var characters = {
	"Lukasz":  preload("res://Characters/lukasz_frames.tres"),
	"LukaszB": preload("res://Characters/LukaszB_frames.tres"),
	"Patryk":  preload("res://Characters/Patryk_frames.tres"),
	"Shimmy":  preload("res://Characters/Shimmy_frames.tres"),
	"Igor":    preload("res://Characters/Igor_frames.tres"),
}

var character_order = ["Lukasz", "LukaszB", "Patryk", "Shimmy", "Igor"]

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
	hbox.offset_left = 0
	hbox.offset_right = -1500
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER

func _make_card(char_name: String) -> VBoxContainer:
	var card = VBoxContainer.new()
	card.alignment = BoxContainer.ALIGNMENT_CENTER
	card.add_theme_constant_override("separation", 16)
	card.custom_minimum_size = Vector2(160, 240)

	var frames = characters[char_name]
	var texture = frames.get_frame_texture("idle_down", 0)

	var preview = TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = Vector2(140, 180)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	card.add_child(preview)

	var btn = Button.new()
	btn.text = char_name
	btn.custom_minimum_size = Vector2(140, 44)
	btn.pressed.connect(func(): _start_game(char_name))
	card.add_child(btn)

	return card

func _start_game(char_name: String):
	AudioManager.play_sfx("res://sounds/buttonpress.wav")
	GameData.wybrana_postac = char_name
	get_tree().change_scene_to_file("res://Levels/d_level_salon_01.tscn")
