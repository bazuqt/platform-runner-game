extends Control

signal resume_signal

signal countdown_sound

func resume_countdown():
	var tween = create_tween()
	for num in get_children():
		tween.tween_property(num, "scale", Vector2(2,2), 1).set_ease(Tween.EASE_OUT)
		tween.tween_property(num, "scale", Vector2(0,0), 0.1).set_ease(Tween.EASE_IN)
		tween.tween_callback(countdown_sound.emit)
	tween.tween_callback(resume_signal.emit)
