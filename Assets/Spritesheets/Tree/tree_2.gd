extends Node2D

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position

func turn_off():
	$Sprite2D/Light.visible = false
