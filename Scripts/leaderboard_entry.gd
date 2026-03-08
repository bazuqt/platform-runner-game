extends HBoxContainer

var starting_score = "0000000"

func set_info(new_info):
	var new_name := str(new_info["name"])
	var new_score := int(new_info["score"])
	var letters = $Name.get_children()
	for i in range(new_name.length()):
		letters[i].text = new_name[i]
	score_rectify(new_score)

func score_rectify(score):
	var length = starting_score.length() - str(score).length()
	var s = ""
	for i in length:
		s+= "0"
	$Score.text = s + str(score)
