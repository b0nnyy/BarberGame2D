extends CharacterBody2D

@export var speed: float = 100.0
@export var clicks_required: int = 3
@export var haircut_icon: Texture2D
@export var beard_icon: Texture2D
@export var golarka_icon: Texture2D 

enum CustomerState { WALKING, SEATED, WAITING, IN_QUEUE, EXITING }
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
# Jeśli klient już wychodzi (nie jest w kolejce ani nie idzie do niej), zignoruj fotel
	if current_state != CustomerState.IN_QUEUE and current_state != CustomerState.WALKING:
		return

	target_seat = seat
	target_position = seat.global_position
	has_target = true
	current_state = CustomerState.WALKING

func set_requested_service(service_name: String):
	requested_service = service_name

func _physics_process(_delta):
	if (current_state == CustomerState.WALKING 
	or current_state == CustomerState.IN_QUEUE 
	or current_state == CustomerState.EXITING) and has_target:
		move_to_seat()

func go_to_waiting_pos(pos: Vector2):
	target_position = pos
	has_target = true
	current_state = CustomerState.IN_QUEUE 

func move_to_seat():
	var direction = target_position - global_position
	if direction.length() > 5:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		has_target = false
	
		if target_seat != null:
			sit_down()
		elif current_state == CustomerState.EXITING:
			queue_free()

func sit_down():
	global_position = target_seat.global_position
	if target_seat.has_method("occupy"):
		target_seat.occupy(self)
	current_state = CustomerState.SEATED
	show_service_icon()
	current_state = CustomerState.WAITING
	print("Customer sat with service: ", requested_service)
func show_service_icon():

	request_icon.visible = false

	match requested_service:

		"haircut":
			request_icon.texture = haircut_icon
			request_icon.visible = true

		"beard":
			request_icon.texture = beard_icon
			request_icon.visible = true

		"golarka":
			request_icon.texture = golarka_icon
			request_icon.visible = true

		_:
			print("Nieznana usługa: ", requested_service)
	print("Showing icon for: ", requested_service)
func take_item(incoming_item):
	if current_state != CustomerState.WAITING: return
	var item_name = incoming_item.name.to_lower()
	var is_correct = false

	if requested_service == "haircut" and item_name.contains("nozyczki"):
		is_correct = true
	elif requested_service == "beard" and item_name.contains("brzytwa"):
		is_correct = true
	elif requested_service == "golarka" and item_name.contains("golarka"): 
		is_correct = true

	if is_correct:
		perform_work_step()

func perform_work_step():
	current_work_progress += 1
	
	# Pasek postępu (jeśli dodałeś węzeł ProgressBar o nazwie WorkProgress)
	if has_node("WorkProgress"):
		$WorkProgress.visible = true
		$WorkProgress.value = current_work_progress
		$WorkProgress.max_value = clicks_required
	var t = create_tween()
	t.tween_property(request_icon, "modulate", Color.GREEN, 0.1)
	t.tween_property(request_icon, "modulate", Color.WHITE, 0.1)
	if current_work_progress >= clicks_required:
		finish_and_leave()
		
func finish_and_leave():
	current_work_progress = 0
	request_icon.visible = false
	
	if target_seat:
		target_seat.release()
		target_seat = null  
	
	current_state = CustomerState.EXITING
	target_position = exit_position
	has_target = true
	
