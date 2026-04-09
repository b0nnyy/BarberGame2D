extends CharacterBody2D

@onready var heart1 = $HeartBar/HBoxContainer/Heart
@onready var heart2 = $HeartBar/HBoxContainer/Heart2
@onready var heart3 = $HeartBar/HBoxContainer/Heart3

@export var move_speed: float = 100
@export var sprint_speed: float = 180
@export var starting_direction: Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var hand = $Hand
@onready var interaction_zone = $InteractionZone


var held_item = null

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)
	update_hearts()

func _physics_process(_delta):

	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	var current_speed = move_speed

	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	velocity = input_direction * current_speed
	move_and_slide()
	update_hearts()

func _input(event):
	if event.is_action_pressed("use_item"):
		attempt_pick_up()

func attempt_pick_up():
	var areas = interaction_zone.get_overlapping_areas()
	var target = null
	for area in areas:
		if area.is_in_group("Interactable"):
			if area.has_method("take_item") or area.get_parent().has_method("take_item"):
				if area.has_method("take_item"):
					target = area
				else:
					target = area.get_parent()
				break
			else:
				target = area
	if target:
		if held_item != null and target.has_method("take_item"):
			target.take_item(held_item)
		elif held_item == null and not target.has_method("take_item"):
			pick_up_item(target)
		elif held_item != null and not target.has_method("take_item"):
			drop_item()
			await get_tree().create_timer(0.1).timeout
			pick_up_item(target)
	elif held_item != null:
		drop_item()

func pick_up_item(item):
	held_item = item
	if held_item.get_parent():
		held_item.get_parent().remove_child(held_item)
	hand.add_child(held_item)
	held_item.position = Vector2.ZERO
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true

func drop_item():
	if not held_item:
		return
	var level = get_tree().current_scene
	var drop_pos = global_position
	hand.remove_child(held_item)
	level.add_child(held_item)
	held_item.global_position = drop_pos
	var shape = held_item.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = false
	held_item = null

func update_hearts():
	heart1.visible = GameManager.lives >= 1
	heart2.visible = GameManager.lives >= 2
	heart3.visible = GameManager.lives >= 3
