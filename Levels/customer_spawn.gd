extends Node2D

@export var customer_scene: PackedScene
@export var spawn_point: Node2D
@export var seats: Array[Node2D]
@export var spawn_interval: float = 1.0

var last_service: String = ""

func _ready():
	randomize()
	call_deferred("start_spawning")

func start_spawning():
	while true:
		spawn_customer()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_customer():
	print("---- PROBA SPAWNU ----")
	print("Liczba foteli w tablicy: ", seats.size())

	var free_seat = get_free_seat()

	if free_seat == null:
		print("Brak wolnych miejsc")
		return

	print("Wybrany fotel: ", free_seat.name)

	var customer = customer_scene.instantiate()
	get_parent().add_child(customer)
	customer.global_position = spawn_point.global_position

	var new_service = get_random_service()
	customer.set_requested_service(new_service)
	last_service = new_service

	free_seat.occupy(customer)
	customer.assign_seat(free_seat)

	print("NOWY KLIENT -> fotel: ", free_seat.name)

func get_free_seat():
	for seat in seats:
		print("Sprawdzam fotel: ", seat.name, " | zajety: ", seat.is_occupied)
		if seat.is_occupied == false:
			return seat
	return null

func get_random_service() -> String:
	var services = ["haircut", "beard", "wash"]
	var available_services = services.duplicate()

	if last_service != "" and available_services.has(last_service):
		available_services.erase(last_service)

	var random_index = randi() % available_services.size()
	return available_services[random_index]
