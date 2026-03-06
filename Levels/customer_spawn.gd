extends Marker2D

@export var customer_scene: PackedScene

func _ready():
	spawn_customer()

func spawn_customer():
	if customer_scene == null:
		print("Brak customer_scene")
		return

	var seat = find_free_seat()

	if seat == null:
		print("Brak wolnych miejsc")
		return

	seat.occupied = true

	var customer = customer_scene.instantiate()
	customer.global_position = global_position

	get_tree().current_scene.call_deferred("add_child", customer)
	customer.call_deferred("go_to_seat", seat.get_node("SeatPoint").global_position)

func find_free_seat():
	var seats = get_tree().get_nodes_in_group("seat_stations")

	for seat in seats:
		if seat.occupied == false:
			return seat

	return null
