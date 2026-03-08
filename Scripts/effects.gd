extends Node2D

var playing := false

func success_anim():
	if not playing:
		playing = true
		var tween = create_tween()
		tween.tween_property($Success, "position", $EndPos.position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_property($Success, "modulate", Color(1,1,1,1), 0.4)
		tween.tween_property($Success, "modulate", Color(1,1,1,0), 0.2)
		tween.tween_callback(reset)
	

func reset():
	playing = false
	$Success.set_position($InitPos.position)
	$Success.set_modulate(Color(1,1,1,0))
