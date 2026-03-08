extends Control

var add_score_scene = preload("res://Scenes/UI/LeaderboardAdd.tscn")

var go_end_pos : Vector2
var btn_end_pos : Vector2
@export var anim_speed : float

func _ready() -> void:
	Global.end_game.connect(game_over)
	go_end_pos = $GOendPos.position
	btn_end_pos = $BttnEndPos.position
	$GOLabel.modulate = Color(1,1,1,0)

func game_over():
	Global.get_player_score.emit()
	var scores = ScoreManager.get_scores()
	var top_score = false
	var last_score = ScoreManager.get_last_score()
	if scores.size() == 0:
		top_score = true
	else:
		if last_score > scores[0]["score"]:
			top_score = true
	if top_score:
		new_top_score_transition()
	else:
		game_over_anim()

func game_over_anim():
	$GOLabel.set_text("Game Over")
	var tween = create_tween()
	tween.tween_property($GOLabel, "position", go_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Buttons, "position", btn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($GOLabel, "modulate", Color(1,1,1,1), anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Buttons, "modulate", Color(1,1,1,1), anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func new_top_score_transition():
	$GOLabel.set_text("New Top Score!")
	var tween = create_tween()
	tween.tween_property($GOLabel, "position", go_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($GOLabel, "modulate", Color(1,1,1,1), anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Fade, "modulate", Color(0,0,0,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Fade, "modulate", Color(0,0,0,1), 0.5)
	tween.tween_callback(_on_add_score_button_pressed).set_delay(1)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")

func _on_add_score_button_pressed() -> void:
	get_tree().change_scene_to_packed(add_score_scene)
