extends Control

@export var ready_marker : Marker2D
@export var inter_marker : Marker2D
var ready_fpos : Vector2
var inter_pos : Vector2

@export var anim_speed : float

func _ready() -> void:
	ready_fpos = ready_marker.position
	inter_pos = inter_marker.position
	level_start_animation()

func level_start_animation():
	var tween = create_tween()
	tween.tween_property($Camera, "position", Vector2(320, 180), 2)
	tween.parallel().tween_property($Ready, "position", inter_pos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Ready, "position", ready_fpos, anim_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Go, "modulate", Color(1,1,1,1), 0.05)
	tween.tween_property($Go, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($Go, "modulate", Color(1,1,1,0), anim_speed/6)
	tween.tween_callback($Audio.play)
	tween.tween_callback(Global.enable_player_cam.emit)
	tween.tween_callback(Global.unpause_game.emit)
	tween.tween_callback(Global.spawn_remote.emit)
	tween.tween_callback(Global.start_scoreboard.emit)
	tween.tween_callback(Global.run_animation.emit)
	tween.tween_callback(Global.disable_vertical_parallax.emit)
	tween.tween_callback(disable_cam)
	tween.tween_callback(queue_free).set_delay(1)

func disable_cam():
	$Camera.enabled = false
