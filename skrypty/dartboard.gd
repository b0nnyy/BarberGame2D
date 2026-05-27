extends Area2D

@export var dart_ui: CanvasLayer
@export var result_icon: Sprite2D  
@export var icon_1: Texture2D
@export var icon_2: Texture2D
@export var icon_3: Texture2D
@export var icon_4: Texture2D
@export var icon_5: Texture2D
@export var icon_6: Texture2D
@export var icon_7: Texture2D
@export var icon_8: Texture2D
@export var icon_9: Texture2D
@export var icon_10: Texture2D
@export var icon_11: Texture2D
@export var icon_12: Texture2D
@export var icon_13: Texture2D
@export var icon_14: Texture2D
@export var icon_15: Texture2D
@export var icon_16: Texture2D
@export var icon_17: Texture2D
@export var icon_18: Texture2D
@export var icon_19: Texture2D
@export var icon_20: Texture2D
@export var icon_25: Texture2D
@export var icon_50: Texture2D



const DART_ZONES = [
	{ "points": 1,  "weight": 10 },
	{ "points": 2,  "weight": 10 },
	{ "points": 3,  "weight": 10 },
	{ "points": 4,  "weight": 10 },
	{ "points": 5,  "weight": 10 },
	{ "points": 6,  "weight": 10 },
	{ "points": 7,  "weight": 10 },
	{ "points": 8,  "weight": 10 },
	{ "points": 9,  "weight": 10 },
	{ "points": 10, "weight": 10 },
	{ "points": 11, "weight": 10 },
	{ "points": 12, "weight": 10 },
	{ "points": 13, "weight": 10 },
	{ "points": 14, "weight": 10 },
	{ "points": 15, "weight": 10 },
	{ "points": 16, "weight": 10 },
	{ "points": 17, "weight": 10 },
	{ "points": 18, "weight": 10 },
	{ "points": 19, "weight": 10 },
	{ "points": 20, "weight": 10 },
	{ "points": 25, "weight": 3  },
	{ "points": 50, "weight": 1  },
]

func _ready():
	add_to_group("Interactable")
	if result_icon:
		result_icon.visible = false

func interact(player):
	dart_ui.open(player, self, global_position)

func get_icon_for_points(points: int) -> Texture2D:
	match points:
		1:  return icon_1
		2:  return icon_2
		3:  return icon_3
		4:  return icon_4
		5:  return icon_5
		6:  return icon_6
		7:  return icon_7
		8:  return icon_8
		9:  return icon_9
		10: return icon_10
		11: return icon_11
		12: return icon_12
		13: return icon_13
		14: return icon_14
		15: return icon_15
		16: return icon_16
		17: return icon_17
		18: return icon_18
		19: return icon_19
		20: return icon_20
		25: return icon_25
		50: return icon_50
	return null

func show_result_icon(points: int):
	var icon = get_icon_for_points(points)
	if icon == null:
		return
	
	result_icon.texture = icon
	result_icon.visible = true
	result_icon.modulate.a = 1.0
	result_icon.scale = Vector2(1, 1)
	
	var t = create_tween()
	t.tween_property(result_icon, "scale", Vector2(1.3, 1.3), 0.15)
	t.tween_property(result_icon, "scale", Vector2(1.0, 1.0), 0.15)
	t.tween_interval(1.0)
	t.tween_property(result_icon, "modulate:a", 0.0, 0.4)
	await t.finished
	result_icon.visible = false

func weighted_random() -> Dictionary:
	var total_weight = 0
	for z in DART_ZONES:
		total_weight += z["weight"]
	var roll = randi() % total_weight
	var cumulative = 0
	for z in DART_ZONES:
		cumulative += z["weight"]
		if roll < cumulative:
			return z
	return DART_ZONES[-1]
