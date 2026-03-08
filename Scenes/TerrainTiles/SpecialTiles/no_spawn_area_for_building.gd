extends Node2D

var lastnum= 0

func get_spawn_point(num: int) -> Vector2:
	lastnum = num
	return $SpawnPoint.position

func get_last_chosen():
	return lastnum+1
