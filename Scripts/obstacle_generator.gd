extends Node2D

@export var obstacle_scene : PackedScene
@export var spawn_time_min : int
@export var spawn_time_max : int

@export var spawn_node : Node2D

var last_spawned_pos : Vector2

func _ready() -> void:
	Global.end_game.connect(stop_spawn)
	Global.unpause_game.connect(start_spawn)
	Global.resume_spawn.connect(start_spawn)
	Global.pause_game.connect(stop_spawn)
	Global.stop_spawn.connect(stop_spawn)
	Global.marker_position.connect(change_marker_pos)
	
func start_spawn() -> void:
	$SpawnTimer.start()

func stop_spawn()-> void:
	$SpawnTimer.stop()

func spawner_timer_randomize() -> void:
	var time_left = randi_range(spawn_time_min, spawn_time_max)
	$SpawnTimer.set_wait_time(time_left)

func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	spawner_timer_randomize()

func spawn_obstacle() -> void:
	if last_spawned_pos.x == $Marker.position.x:
		Global.marker_position.emit()
	var new_obstacle = obstacle_scene.instantiate()
	new_obstacle.position = $Marker.position
	last_spawned_pos = new_obstacle.position
	add_child(new_obstacle)

func change_marker_pos():
	$Marker.position.x = Global.player_position + 600
