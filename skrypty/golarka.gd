extends Area2D

var home_position: Vector2

func _ready():
	home_position = global_position

func return_home():
	var level = get_tree().current_scene
	

	if get_parent() != level:
		get_parent().remove_child(self)
		level.add_child(self)
	
	global_position = home_position
	

	var shape = get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = false
