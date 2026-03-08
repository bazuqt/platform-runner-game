extends Node2D

var light 

func _ready() -> void:
	light = $LightBluePointLight2D

func turnoffon() -> void:
	light.visible = not light.visible

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position


func _on_timer_timeout() -> void:
	turnoffon()
