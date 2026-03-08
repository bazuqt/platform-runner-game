extends Control

var level_scene = preload("res://Scenes/Level.tscn")

var startbtn_end_pos : Vector2
var quitbtn_end_pos : Vector2
var clouds_end_pos : Vector2
var title_end_pos : Vector2
var startbtn_init_pos : Vector2
var quitbtn_init_pos : Vector2
var credbtn_init_pos : Vector2
var title_init_pos : Vector2
var clouds_init_pos : Vector2
var clouds_game_pos : Vector2
var title_creds_pos : Vector2
var options_init_pos : Vector2

@export var anim_speed = 1

func _ready() -> void:
	startbtn_end_pos = %StartEndPos.position
	quitbtn_end_pos = %QuitEndPos.position
	clouds_end_pos = %CloudEndPos.position
	title_end_pos = %TitleEndPos.position
	startbtn_init_pos = %StartInitPos.position
	quitbtn_init_pos = %QuitInitPos.position
	credbtn_init_pos = %CreditsInitPos.position
	title_init_pos = %TitleInitPos.position
	clouds_init_pos = %CloudsInitPos.position
	clouds_game_pos = %CloudsGamePos.position
	title_creds_pos = %TitleCredPos.position
	options_init_pos = %OptionsInitPos.position
	
	Global.in_main_menu_buttons.connect(in_buttons)

func _on_start_game_pressed() -> void:
	disable_buttons()
	title_out(2)
	start_game_buttons()

func _on_credits_pressed() -> void:
	disable_buttons()
	out_buttons()
	title_creds()
	$CreditsMenu.in_credits()

func _on_leader_board_pressed() -> void:
	disable_buttons()
	out_buttons()
	title_out(0.5)
	$LeaderboardShow.in_leaderboard()


func _on_options_pressed() -> void:
	disable_buttons()
	out_buttons()
	title_out(0.5)
	$OptionsMenu.in_options()


func _on_quit_pressed() -> void:
	get_tree().quit()

func in_buttons():
	var tween = create_tween()
	tween.tween_property($Title, "position", title_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($StartGame, "position", startbtn_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($SecondRow, "position", credbtn_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Options, "position", options_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Quit, "position", quitbtn_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($StartGame, "modulate", Color(1,1,1,1), 0.8)
	tween.parallel().tween_property($SecondRow, "modulate", Color(1,1,1,1), 0.8)
	tween.parallel().tween_property($Options, "modulate", Color(1,1,1,1), 0.8)
	tween.parallel().tween_property($Quit, "modulate", Color(1,1,1,1), 0.8)
	tween.parallel().tween_property($ParallaxClouds, "scroll_offset", clouds_init_pos, anim_speed)
	tween.parallel().tween_property($Background, "position", Vector2(0,-360), 0.9).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(enable_buttons)

func out_buttons():
	var tween = create_tween()
	tween.tween_property($StartGame, "position", startbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($SecondRow, "position", quitbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Options, "position", quitbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Quit, "position", quitbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($StartGame, "modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($SecondRow, "modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($Options, "modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($Quit, "modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($ParallaxClouds, "scroll_offset", clouds_end_pos, anim_speed)
	tween.parallel().tween_property($Background, "position", Vector2(0,0), 0.9).set_trans(Tween.TRANS_EXPO)

func title_creds():
	var tween = create_tween()
	tween.tween_property($Title, "position", title_creds_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func title_out(speed : float):
	var tween = create_tween()
	tween.tween_property($Title, "position", title_end_pos, speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func start_game_buttons():
	var tween = create_tween()
	tween.tween_property($StartGame, "position", startbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($SecondRow, "position", startbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Options, "position", startbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Quit, "position", startbtn_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Title, "modulate", Color(1,1,1,0), 1.3)
	tween.parallel().tween_property($StartGame, "modulate", Color(1,1,1,0), 0.4)
	tween.parallel().tween_property($SecondRow, "modulate", Color(1,1,1,0), 0.6)
	tween.parallel().tween_property($Options, "modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($Quit, "modulate", Color(1,1,1,0), 1)
	tween.parallel().tween_property($ParallaxClouds, "scroll_offset", clouds_game_pos, anim_speed)
	tween.parallel().tween_property($Background, "position", Vector2(0,-1080), 1.5).set_trans(Tween.TRANS_EXPO)
	tween.chain().tween_callback(scene_change)

func scene_change():
	get_tree().change_scene_to_packed(level_scene)

func disable_buttons():
	$StartGame.set_disabled(true)
	%Credits.set_disabled(true)
	%LeaderBoard.set_disabled(true)
	$Options.set_disabled(true)
	$Quit.set_disabled(true)

func enable_buttons():
	$StartGame.set_disabled(false)
	%Credits.set_disabled(false)
	%LeaderBoard.set_disabled(false)
	$Options.set_disabled(false)
	$Quit.set_disabled(false)
