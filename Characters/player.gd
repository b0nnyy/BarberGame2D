extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var hand = $Hand
@onready var interaction_zone = $InteractionZone

var held_item = null 

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * move_speed
	move_and_slide()

func _input(event):
	if event.is_action_pressed("use_item"):
		attempt_pick_up()

func attempt_pick_up():
	var areas = interaction_zone.get_overlapping_areas()
	var target = null 

	# 1. SZUKAMY CELU
	for area in areas:
		if area.is_in_group("Interactable"):
			# Najpierw sprawdzamy, czy to NPC (ma metodę take_item)
			if area.has_method("take_item") or area.get_parent().has_method("take_item"):
				if area.has_method("take_item"):
					target = area
				else:
					target = area.get_parent()
				break # Priorytet dla klienta
			else:
				# Jeśli to nie NPC, to znaczy że to przedmiot (np. nożyczki na ziemi)
				target = area
				# Nie robimy break, szukamy dalej czy w tym samym miejscu nie stoi klient

	# 2. LOGIKA INTERAKCJI
	if target:
		# SCENARIUSZ A: Trzymasz coś i klikasz na KLIENTA -> Użyj
		if held_item != null and target.has_method("take_item"):
			print("Używam przedmiotu na kliencie")
			target.take_item(held_item)
		
		# SCENARIUSZ B: Nic nie trzymasz i klikasz na PRZEDMIOT -> Podnieś
		elif held_item == null and not target.has_method("take_item"):
			print("Podnoszę przedmiot")
			pick_up_item(target)
			
		# SCENARIUSZ C: Trzymasz coś i klikasz na INNY PRZEDMIOT na ziemi -> Zamień (opcjonalnie)
		# Na razie zróbmy proste: odłóż i podnieś nowy
		elif held_item != null and not target.has_method("take_item"):
			drop_item()
			# Mała pauza, żeby system zdążył zarejestrować zmianę
			await get_tree().create_timer(0.1).timeout 
			pick_up_item(target)

	# 3. SCENARIUSZ D: Klikasz w puste miejsce trzymając coś -> Odłóż
	elif held_item != null:
		print("Kładę przedmiot na ziemię")
		drop_item()

func pick_up_item(item):
	held_item = item
	if held_item.get_parent():
		held_item.get_parent().remove_child(held_item)
	hand.add_child(held_item)
	held_item.position = Vector2.ZERO
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape: shape.disabled = true

func drop_item():
	if not held_item: return
	var level = get_tree().current_scene
	var drop_pos = global_position 
	hand.remove_child(held_item)
	level.add_child(held_item)
	held_item.global_position = drop_pos
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape: shape.disabled = false
	held_item = null
