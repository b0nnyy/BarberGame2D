extends CharacterBody2D

@export var speed: float = 100.0
@export var clicks_required: int = 3

@export var haircut_icon: Texture2D
@export var beard_icon: Texture2D
@export var golarka_icon: Texture2D
@export var happy_icon: Texture2D
@export var angry_icon: Texture2D
@export var haircut_frames: SpriteFrames
@export var beard_frames: SpriteFrames
@export var golarka_frames: SpriteFrames

enum CustomerState { WALKING, SEATED, WAITING, IN_QUEUE, EXITING }
var current_state = CustomerState.WALKING

var target_seat = null
var target_position: Vector2
var has_target: bool = false
var exit_position: Vector2
var requested_service: String = ""

var current_work_progress: int = 0

var patience: float = 100
var patience_decay: float = 5
var is_angry: bool = false
var has_already_failed := false

var last_direction = "down"

@onready var reaction_icon = $ReactionIcon
@onready var request_icon = $RequestIcon
@onready var patience_bar = $PatienceBar
@onready var score_popup = $ScorePopup
@onready var nav_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	request_icon.visible = false
	score_popup.visible = false
	reaction_icon.visible = false
	
	request_icon.position = Vector2(0, -40)
	
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

func assign_seat(seat):

	if current_state != CustomerState.IN_QUEUE and current_state != CustomerState.WALKING:
		return

	target_seat = seat
	set_target(seat.global_position)

	current_state = CustomerState.WALKING

func set_requested_service(service_name: String):

	requested_service = service_name

	match requested_service:

		"haircut":
			animated_sprite.sprite_frames = haircut_frames

		"beard":
			animated_sprite.sprite_frames = beard_frames

		"golarka":
			animated_sprite.sprite_frames = golarka_frames

func set_target(pos: Vector2):

	target_position = pos
	nav_agent.target_position = pos
	has_target = true

func become_angry():

	is_angry = true
	request_icon.modulate = Color(1,0.3,0.3)

	var t = create_tween()
	t.set_loops()

	t.tween_property(request_icon,"rotation",0.15,0.1)
	t.tween_property(request_icon,"rotation",-0.15,0.1)

func leave_angry():

	if has_already_failed:
		return

	has_already_failed = true

	print("Klient się wkurzył i wychodzi!")

	request_icon.visible = false
	patience_bar.visible = false
	
	show_reaction(false)

	if target_seat:
		target_seat.release()
		target_seat = null

	GameManager.lose_life()
	current_state = CustomerState.EXITING
	set_target(exit_position)

func update_patience(delta):
	patience -= patience_decay * delta
	patience_bar.value = patience
	
	var fill_style = patience_bar.get_theme_stylebox("fill").duplicate()
	if patience > 60:
		fill_style.bg_color = Color(0.2, 0.8, 0.2)  
	elif patience > 30:
		fill_style.bg_color = Color(0.9, 0.7, 0.0)  
	else:
		fill_style.bg_color = Color(0.8, 0.2, 0.2)  
	patience_bar.add_theme_stylebox_override("fill", fill_style)

	if patience < 40 and not is_angry:
		become_angry()

	if patience <= 0 and current_state != CustomerState.EXITING:
		leave_angry()

func _physics_process(delta):

	if current_state == CustomerState.WAITING:
		update_patience(delta)

	if has_target:
		move_to_target()

	update_animation(velocity)

func go_to_waiting_pos(pos: Vector2):

	set_target(pos)

	current_state = CustomerState.IN_QUEUE

func move_to_target():

	if nav_agent.is_navigation_finished():

		velocity = Vector2.ZERO
		move_and_slide()

		has_target = false

		if target_seat != null:
			sit_down()

		elif current_state == CustomerState.EXITING:
			queue_free()

		return

	var next_path_position = nav_agent.get_next_path_position()

	var direction = (next_path_position - global_position).normalized()

	velocity = direction * speed

	move_and_slide()

func sit_down():

	global_position = target_seat.global_position

	if target_seat.has_method("occupy"):
		target_seat.occupy(self)

	current_state = CustomerState.SEATED
	
	if animated_sprite.sprite_frames.has_animation("sit_front"):
		animated_sprite.play("sit_front")

	show_service_icon()

	current_state = CustomerState.WAITING

	patience = 100
	patience_bar.value = patience
	patience_bar.visible = true

	has_already_failed = false

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

func take_item(incoming_item):
	if current_state != CustomerState.WAITING:
		return

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
	patience_bar.visible = false
	show_reaction(true)
	GameManager.add_score(int(patience / 10))
	show_score_popup()

 
	var player = get_tree().get_first_node_in_group("player")
	if player and player.held_item:
		if player.held_item.has_method("return_home"):
			player.held_item.return_home()
		player.held_item = null

	if target_seat:
		target_seat.release()
		target_seat = null

	current_state = CustomerState.EXITING
	set_target(exit_position)

func show_score_popup():

	score_popup.visible = true

	score_popup.modulate = Color(1,1,1,1)
	score_popup.position = Vector2(0, -80)

	var t = create_tween()

	t.tween_property(score_popup, "scale", Vector2(1.3,1.3), 0.1)
	t.tween_property(score_popup, "scale", Vector2(1,1), 0.1)

	t.tween_property(score_popup, "position:y", -140, 0.5)

	t.parallel().tween_property(score_popup, "modulate:a", 0, 0.5)

	await t.finished

	score_popup.visible = false
	score_popup.modulate.a = 1

func update_animation(direction: Vector2):

	if current_state == CustomerState.WAITING or current_state == CustomerState.SEATED:
		return
	if direction == Vector2.ZERO:
		animated_sprite.play("idle_" + last_direction)
		return
	var anim = ""
	if abs(direction.y) > abs(direction.x):
		if direction.y > 0:
			anim = "walk_down"
			last_direction = "down"
		else:
			anim = "walk_up"
			last_direction = "up"
	else:
		if direction.x > 0:

			anim = "walk_right"
			last_direction = "right"
		else:

			anim = "walk_left"
			last_direction = "left"

	if animated_sprite.animation != anim:
		animated_sprite.play(anim)

func show_reaction(happy: bool):
	reaction_icon.texture = happy_icon if happy else angry_icon
	reaction_icon.visible = true
	reaction_icon.modulate.a = 1.0
	reaction_icon.scale = Vector2(1, 1)
	var t = create_tween()
	t.tween_property(reaction_icon, "scale", Vector2(1.3, 1.3), 0.15)
	t.tween_property(reaction_icon, "scale", Vector2(1.0, 1.0), 0.15)
	t.tween_interval(0.8)
	t.tween_property(reaction_icon, "modulate:a", 0.0, 0.4)
	await t.finished
	reaction_icon.visible = false
