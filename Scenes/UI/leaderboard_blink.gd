extends HBoxContainer

var score : int
var entry_name : String

var starting_score = "0000000"

func _ready() -> void:
	score = ScoreManager.get_last_score()
	score_rectify()

func score_rectify():
	var length = starting_score.length() - str(score).length()
	var s = ""
	for i in length:
		s+= "0"
	$Score.text = s + str(score)

func get_entry_name() -> String:
	entry_name = ""
	for letter in $Name.get_children():
		entry_name += letter.get_letter()
	return entry_name

func get_score() -> int:
	return score
