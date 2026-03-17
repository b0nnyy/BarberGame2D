extends Node2D

var is_occupied: bool = false
var is_reserved: bool = false 

func reserve():
	is_reserved = true


func occupy(customer):
	is_occupied = true
	is_reserved = false 
	print("Fotel zajęty przez: ", customer.name)


func release():
	is_occupied = false
	is_reserved = false
	print("Fotel ", name, " jest teraz całkowicie wolny.")
