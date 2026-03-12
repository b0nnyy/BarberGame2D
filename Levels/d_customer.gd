extends CharacterBody2D

@export var speed: float = 100.0

@export var haircut_icon: Texture2D
@export var beard_icon: Texture2D
@export var wash_icon: Texture2D

enum CustomerState {
	WALKING,
	SEATED,
	WAITING
}

var current_state = CustomerState.WALKING

var target_seat = null
var target_position: Vector2
var has_target: bool = false

var requested_service: String = ""

@onready var request_icon = $RequestIcon

func _ready():
	request_icon.visible = false

func assign_seat(seat):
	target_seat = seat
	target_position = seat.global_position
	has_target = true
	current_state = CustomerState.WALKING

func set_requested_service(service_name: String):
	requested_service = service_name
	print("Klient chce uslugi: ", requested_service)

func _physics_process(_delta):
	if current_state == CustomerState.WALKING and has_target:
		move_to_seat()

func move_to_seat():
	var direction = target_position - global_position

	if direction.length() > 5:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
		has_target = false
		sit_down()

	move_and_slide()

func sit_down():
	global_position = target_seat.global_position
	print("KLIENT USIADL NA: ", target_seat.name, " POZYCJA: ", global_position)

	current_state = CustomerState.SEATED
	show_service_icon()
	current_state = CustomerState.WAITING

func show_service_icon():
	if requested_service == "haircut":
		request_icon.texture = haircut_icon
	elif requested_service == "beard":
		request_icon.texture = beard_icon
	elif requested_service == "wash":
		request_icon.texture = wash_icon

	request_icon.visible = true
