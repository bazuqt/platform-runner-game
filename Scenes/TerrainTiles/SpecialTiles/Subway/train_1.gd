extends StaticBody2D 

func _ready() -> void:
	Global.end_game.connect(stop_anim)

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position

func stop_anim():
	$Audio.stop()
	$TrainCart1.stop()
	$TrainCart2.stop()
	$TrainCart3.stop()
