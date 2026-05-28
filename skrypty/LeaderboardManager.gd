extends Node

const SAVE_PATH := "user://leaderboard.save"

var scores: Array = []


func _ready():
	load_scores()


func add_score(player_name: String, score: int):
	scores.append({
		"name": player_name,
		"score": score
	})

	sort_scores()
	save_scores()


func sort_scores():
	scores.sort_custom(func(a, b):
		return a["score"] > b["score"]
	)


func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		print("Nie udało się zapisać leaderboardu")
		return

	file.store_var(scores)


func load_scores():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		print("Nie udało się wczytać leaderboardu")
		return

	var loaded_scores = file.get_var()

	if loaded_scores is Array:
		scores = loaded_scores
		sort_scores()


func get_rank_for_score(score: int) -> int:

	for i in range(scores.size()):
		if scores[i]["score"] <= score:
			return i + 1

	return scores.size() + 1
