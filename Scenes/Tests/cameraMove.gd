extends Camera2D

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_D):
		position.x += 5
	elif Input.is_key_pressed(KEY_A):
		position.x -= 5
