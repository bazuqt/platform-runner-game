extends Node2D

var light
var Arrowindicator

func _ready() -> void:
	Arrowindicator = $RedArrow
	Global.end_game.connect(stop_anim)

func turnoffon() -> void:
	Arrowindicator.visible = not Arrowindicator.visible

func get_spawn_point() -> Vector2:
	return $SpawnPoint.position

func _on_timer_timeout() -> void:
	turnoffon()

func stop_anim():
	$Timer.stop()
	$Train1/AnimationPlayer.set_active(false)

func _on_exit_condition_body_entered(body: Node2D) -> void:
	Global.resume_spawn.emit()
