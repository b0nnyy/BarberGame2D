extends Node2D

var is_occupied: bool = false
var is_reserved: bool = false # Blokada dla klienta, który jest w drodze

# Funkcja wywoływana przez Spawner, gdy klient rusza z kolejki
func reserve():
	is_reserved = true

# Funkcja wywoływana przez Klienta, gdy fizycznie usiądzie (sit_down)
func occupy(customer):
	is_occupied = true
	is_reserved = false 
	print("Fotel zajęty przez: ", customer.name)

# Funkcja wywoływana przez Klienta, gdy skończy usługę i wstaje
func release():
	is_occupied = false
	is_reserved = false
	print("Fotel ", name, " jest teraz całkowicie wolny.")
