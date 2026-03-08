extends Control

func _ready() -> void:
	in_add_lead()
	populate_high_scores()

func _on_confirm_pressed() -> void:
	var entry_name = $HighScores/LeaderboardNew.get_entry_name()
	var entry_score = $HighScores/LeaderboardNew.get_score()
	var score = {
		"name": entry_name,
		"score": entry_score
	}
	ScoreManager.submit_score(score)
	out_add_lead()

func in_add_lead():
	var tween = create_tween()
	tween.tween_property($Curtain, "modulate", Color(0,0,0,0), 0.5).set_ease(Tween.EASE_OUT)

func out_add_lead():
	var tween = create_tween()
	tween.tween_property($Curtain, "modulate", Color(0,0,0,1), 0.5).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(scene_change)

func populate_high_scores():
	var high_scores = ScoreManager.get_scores()
	if high_scores.size() >= 1:
		var ran = min(5, high_scores.size())
		for i in range(1, ran):
			$HighScores.get_child(i).set_info(high_scores[i-1])
			$HighScores.get_child(i).show()

func scene_change():
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
