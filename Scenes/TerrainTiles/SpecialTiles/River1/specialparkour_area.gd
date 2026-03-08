extends Node2D

var light
var FlashingArrow 

func _ready():
	Global.end_game.connect(stop_anim)
	light = $RedPointLight 	
	FlashingArrow = $ArrowFlashing

func turnoffon() -> void:
	light.visible = not light.visible
	FlashingArrow.visible = not FlashingArrow.visible

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position

@export var sprite_list : Array[Resource]
var spawnMarker : Marker2D

func deactivate():
	$Area2D/Hitbox.set_deferred("disabled", true)

func stop_anim():
	$Timer.stop()

func _on_timer_timeout() -> void:
	turnoffon()

func _on_park_cam_body_entered(_body: Node2D) -> void:
	Global.parkour_cam.emit()
	Global.stop_spawn.emit()

func _on_exit_cam_body_entered(_body: Node2D) -> void:
	Global.normal_cam.emit()
	Global.resume_spawn.emit()
	
