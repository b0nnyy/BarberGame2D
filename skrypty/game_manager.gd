extends Node

var score: int = 0
var lives: int = 3
var game_over: bool = false

func add_score(points: int):
	if game_over:
		return
	score += points

func lose_life():

	lives -= 1

	if lives <= 0:

		get_tree().current_scene.show_game_over(score)

func trigger_game_over():
	if game_over:
		return
	
	game_over = true
	print("GAME OVER")

	var scene = get_tree().current_scene

	if scene.has_method("show_game_over"):
		scene.show_game_over(score)

func reset_game():
	score = 0
	lives = 3
	game_over = false
