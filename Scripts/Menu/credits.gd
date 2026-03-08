extends Control

@export var out_pos_markerbtn : Marker2D
@export var in_pos_markerbtn : Marker2D
@export var out_pos_marker : Marker2D
@export var in_pos_marker : Marker2D

var out_posbtn : Vector2
var in_posbtn : Vector2
var out_pos : Vector2
var in_pos : Vector2

func _ready() -> void:
	out_posbtn = out_pos_markerbtn.position
	in_posbtn = in_pos_markerbtn.position
	out_pos = out_pos_marker.position
	in_pos = in_pos_marker.position

func in_credits():
	show()
	var tween = create_tween()
	tween.tween_property($Exit, "position", in_posbtn, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Credits, "position", in_pos, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(enable_button)

func out_credits():
	$Exit.set_disabled(true)
	var tween = create_tween()
	tween.tween_property($Exit, "position", out_posbtn, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Credits, "position", out_pos, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(hide)

func enable_button():
	$Exit.set_disabled(false)

func _on_exit_pressed() -> void:
	Global.in_main_menu_buttons.emit()
	out_credits()
