extends Node2D

var is_occupied: bool = false
var assigned_customer = null

func occupy(customer):
	is_occupied = true
	assigned_customer = customer

func free_seat():
	is_occupied = false
	assigned_customer = null
