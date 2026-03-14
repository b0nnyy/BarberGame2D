extends Node2D

@export var customer_scene: PackedScene
@export var spawn_point: Node2D
@export var seats: Array[Node2D]
@export var spawn_interval: float = 4.0
@export var queue_positions: Array[Marker2D]

var waiting_queue: Array = []
var last_service: String = ""
var active_customers: Array = []


func _ready():
	randomize()
	call_deferred("start_spawning")

func start_spawning():

	while true:

		spawn_customer()
		try_send_customer_to_seat()

		await get_tree().create_timer(spawn_interval).timeout
		
func try_send_customer_to_seat():

	if waiting_queue.is_empty():
		return

	var seat = get_free_seat()

	if seat == null:
		return

	var customer = waiting_queue.pop_front()

	seat.reserve()
	customer.assign_seat(seat)

	update_queue_positions()

func get_free_seat():
	for seat in seats:
		if not seat.is_occupied and not seat.is_reserved:
			return seat
	return null

func spawn_customer():
	
	if waiting_queue.size() >= queue_positions.size():
		return

	var customer = customer_scene.instantiate()
	get_parent().add_child(customer)

	customer.global_position = spawn_point.global_position
	customer.exit_position = spawn_point.global_position

	var new_service = get_random_service()
	customer.set_requested_service(new_service)

	active_customers.append(customer)
	waiting_queue.append(customer)

	update_queue_positions()
	print("Spawn service: ", new_service)
func update_queue_positions():

	var max_index = min(waiting_queue.size(), queue_positions.size())

	for i in range(max_index):

		var customer = waiting_queue[i]

		if not is_instance_valid(customer):
			continue

		var target_pos = queue_positions[i].global_position + Vector2(0, i * 2)

		if customer.target_position != target_pos:
			customer.go_to_waiting_pos(target_pos)

func get_random_service() -> String:
	var services = ["haircut", "beard", "golarka"]
	return services[randi() % services.size()]
