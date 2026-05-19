extends Area2D

@export var dart_ui: CanvasLayer 

const DART_ZONES = [
	{ "label": "BULLSEYE", "points": 50, "weight": 1 },
	{ "label": "Bull",     "points": 25, "weight": 3 },
	{ "label": "Trójka",   "points": 3,  "weight": 8 },
	{ "label": "Dwójka",   "points": 2,  "weight": 8 },
	{ "label": "Jedynka",  "points": 1,  "weight": 10 },
	{ "label": "Pudło",    "points": 0,  "weight": 6 },
]

func _ready():
	add_to_group("Interactable")


func interact(player):
	dart_ui.open(player, self)

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
