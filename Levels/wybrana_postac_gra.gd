extends Node

func _ready():

	print("Wybrana postać to: " + GameData.wybrana_postac)

@onready var pause_menu = $UI/PauseMenu


func _input(event):

	if event.is_action_pressed("ui_cancel"):

		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()


func _pause_game():

	get_tree().paused = true
	
	pause_menu.visible = true


func _resume_game():

	get_tree().paused = false
	pause_menu.visible = false
