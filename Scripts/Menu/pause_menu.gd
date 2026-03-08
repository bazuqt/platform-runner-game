extends Control

var btns_init_pos : Vector2
var btns_end_pos : Vector2

var anim_speed := 0.2

@export var sounds : Array[AudioStreamMP3]

var sound_index := 0

func _ready() -> void:
	btns_init_pos = $BtnsInitPos.position
	btns_end_pos = $BtnsEndPos.position
	Global.in_main_menu_buttons.connect(return_menu)
	$ResumeCounter.countdown_sound.connect(play_countdown_sound)

func _on_resume_pressed() -> void:
	out_menu()
	$ResumeCounter.resume_countdown()

func _on_options_pressed() -> void:
	out_menu()
	$Options.in_options()

func _on_credits_pressed() -> void:
	out_menu()
	$Credits.in_credits()

func _on_main_menu_pressed() -> void:
	var tw = create_tween()
	tw.tween_callback(change_scene).set_delay(0.5)

func change_scene():
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

func out_menu() -> void:
	disable_buttons()
	var tween = create_tween()
	tween.tween_property($Buttons, "position", btns_end_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(hide_back)

func in_menu() -> void:
	enable_buttons()
	var tween = create_tween()
	tween.tween_property($Buttons, "position", btns_init_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(show_back)

func return_menu() -> void:
	enable_buttons()
	var tween = create_tween()
	tween.tween_property($Buttons, "position", btns_init_pos, anim_speed * 5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(show_back)

func hide_back():
	var tween = create_tween()
	tween.parallel().tween_property($Background, "modulate", Color(0,0,0,0), anim_speed)

func show_back():
	var tween = create_tween()
	$Background.show()
	tween.parallel().tween_property($Background, "modulate", Color(0,0,0,0.8), anim_speed)

func disable_buttons() -> void:
	for button in $Buttons.get_children():
		button.set_disabled(true)

func enable_buttons() -> void:
	for button in $Buttons.get_children():
		button.set_disabled(false)

func play_countdown_sound():
	$Audio.play_sound(sounds[sound_index])
	sound_index += 1
	if sound_index > 3:
		sound_index = 0
