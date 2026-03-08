extends Node2D

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position

func turn_off():
	$LightBluePointLight2D.visible = false
	$Busstop2/LightOccluder2D.visible = false
