extends CharacterBody2D

@export var speed: float = 100.0
@export var clicks_required: int = 3 
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
var exit_position: Vector2
var requested_service: String = ""
var current_work_progress: int = 0

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
		var direction = target_position - global_position
		if direction.length() < 10 and target_position == exit_position:
			queue_free() 
		else:
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



func take_item(incoming_item):
	# Reagujemy tylko jeśli klient czeka na fotelu
	if current_state != CustomerState.WAITING:
		return

	var item_name = incoming_item.name.to_lower()
	
	# Sprawdzanie czy narzędzie pasuje do chęci klienta
	var can_work = false
	if requested_service == "haircut" and item_name.contains("nozyczki"):
		can_work = true
	elif requested_service == "beard" and (item_name.contains("brzytwa") or item_name.contains("golarka")):
		can_work = true
	elif requested_service == "wash":
		can_work = true # Tu dodasz np. szampon

	if can_work:
		perform_work_step()
	else:
		print("To nie to narzędzie! Klient chce: ", requested_service)

func perform_work_step():
	current_work_progress += 1
	print("Praca w toku: ", current_work_progress, "/", clicks_required)
	
	# Efekt wizualny kliknięcia (opcjonalne)
	var t = create_tween()
	t.tween_property(request_icon, "modulate", Color.GREEN, 0.1)
	t.tween_property(request_icon, "modulate", Color.WHITE, 0.1)

	if current_work_progress >= clicks_required:
		finish_and_leave()
		
func finish_and_leave():
	print("Usługa zakończona!")
	current_work_progress = 0
	request_icon.visible = false
	
	# Zwolnienie fotela
	if target_seat:
		target_seat.release()
	
	# Powrót do wyjścia
	current_state = CustomerState.WALKING
	target_position = exit_position
	has_target = true

func complete_service():
	print("Klient: Dziękuję! Do widzenia.")
	request_icon.visible = false
	

	if target_seat and target_seat.has_method("release"):
		target_seat.release()
	
	
	current_state = CustomerState.WALKING
	target_position = exit_position 
	has_target = true
