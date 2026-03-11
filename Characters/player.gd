extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	

	velocity = input_direction * move_speed

	move_and_slide()
	

@onready var hand = $Hand
@onready var interaction_zone = $InteractionZone

var held_item = null # Tu będziemy przechowywać referencję do przedmiotu

func _input(event):
	if event.is_action_pressed("Interact"): # Zmień na swoją nazwę akcji
		if held_item:
			drop_item()
		else:
			attempt_pick_up()

func attempt_pick_up():
	# Pobieramy wszystkie Area2D w zasięgu gracza
	var areas = interaction_zone.get_overlapping_areas()
	
	for area in areas:
		if area.is_in_group("Interactable"):
			pick_up_item(area)
			break # Podnosimy tylko pierwszy znaleziony przedmiot

func pick_up_item(item):
	held_item = item
	
	# "Odnapinamy" przedmiot od mapy i przypinamy do dłoni
	if held_item.get_parent():
		held_item.get_parent().remove_child(held_item)
	
	hand.add_child(held_item)
	
	# Resetujemy pozycję lokalną przedmiotu do (0,0) markera Hand
	held_item.position = Vector2.ZERO
	
	# Wyłączamy kolizję przedmiotu, żeby nie przeszkadzał graczowi podczas chodzenia
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true
	
	print("Podniesiono: ", held_item.name)

func drop_item():
	if not held_item:
		return
		
	# Pobieramy aktualną scenę (mapę), żeby tam odłożyć przedmiot
	var level = get_tree().current_scene
	var drop_pos = global_position # Miejsce pod stopami gracza
	
	# Odpinamy z dłoni i przypinamy do poziomu
	hand.remove_child(held_item)
	level.add_child(held_item)
	
	# Ustawiamy pozycję na mapie i włączamy kolizję
	held_item.global_position = drop_pos
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = false
		
	print("Upuszczono: ", held_item.name)
	held_item = null
