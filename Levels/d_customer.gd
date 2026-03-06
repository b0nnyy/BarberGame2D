extends CharacterBody2D

var target_position: Vector2
var speed: float = 120.0
var moving: bool = false

func _physics_process(delta):

	if moving == false:
		return

	var direction = target_position - global_position

	if direction.length() < 5:
		velocity = Vector2.ZERO
		moving = false
		print("Klient usiadl")
		return

	velocity = direction.normalized() * speed
	move_and_slide()

func go_to_seat(pos: Vector2):
	target_position = pos
	moving = true
