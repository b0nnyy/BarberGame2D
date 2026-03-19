extends Node

var score: int = 0
var lives: int = 3
var game_over: bool = false

func add_score(points: int):
	if game_over:
		return
	score += points

func lose_life():
	if game_over:
		return
	
	lives -= 1
	
	if lives < 0:
		lives = 0
	
	if lives == 0:
		trigger_game_over()

func trigger_game_over():
	if game_over:
		return
	
	game_over = true
	print("GAME OVER")
	get_tree().paused = true
