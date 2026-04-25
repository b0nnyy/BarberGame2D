extends Node2D

var base_y := 0.0
var time := 0.0

func _ready():
	base_y = position.y

func _process(delta):
	time += delta
	position.y = round(base_y + sin(time * 2.0) * 3)
