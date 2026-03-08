extends Control

var lead_entry_scene = preload("res://Scenes/UI/LeaderboardEntry.tscn")

var score_init_pos : Vector2
var score_end_pos : Vector2
var btn_init_pos : Vector2
var btn_end_pos : Vector2

var scores = []

func _ready() -> void:
	score_init_pos = $ScoreInitPos.position
	score_end_pos = $ScoreEndPos.position
	btn_init_pos = $ButtonInitPos.position
	btn_end_pos = $ButtonEndPos.position
	scores = ScoreManager.get_scores()
	prepare_scores()

func prepare_scores():
	if scores:
		$NoScoresLabel.set_modulate(Color(1,1,1,0))
		$Scores.set_modulate(Color(1,1,1,1))
		populate_scores()
	else:
		$Scores.set_modulate(Color(1,1,1,0))
		$NoScoresLabel.set_modulate(Color(1,1,1,1))

func populate_scores():
	for i in scores.size():
		var entry = lead_entry_scene.instantiate()
		entry.set_info(scores[i])
		%HighScores.add_child(entry)

func in_leaderboard():
	show()
	var tween = create_tween()
	tween.tween_property($Scores, "position", score_end_pos, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Back, "position", btn_end_pos, 0.7).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($NoScoresLabel, "position", score_end_pos, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func out_leaderboard():
	var tween = create_tween()
	tween.tween_property($Scores, "position", score_init_pos, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Back, "position", btn_init_pos, 0.7).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($NoScoresLabel, "position", score_init_pos, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(hide)

func _on_back_pressed() -> void:
	out_leaderboard()
	Global.in_main_menu_buttons.emit()
