extends Node

var scores = []
var last_score := 0

func _ready() -> void:
	if not load_scores():
		save_scores()
	scores = load_scores()

func set_last_score(new_last_score : int):
	last_score = new_last_score

func get_last_score() -> int:
	return last_score

func load_scores():
	print(ProjectSettings.globalize_path("user://scores.json"))
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	if file:
		var json = file.get_as_text()
		file.close()
		return JSON.parse_string(json)
	else:
		return null

func save_scores():
	var file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	var json = JSON.stringify(scores)
	file.store_string(json)
	file.close()

func submit_score(new_score):
	var index = -1
	for i in range(scores.size()):
		if scores[i]["score"] <= new_score["score"]:
			index = i
			break
	
	if index == -1:
		scores.push_back(new_score)
	else:
		scores.insert(index, new_score)
	save_scores()

func get_scores():
	return scores
