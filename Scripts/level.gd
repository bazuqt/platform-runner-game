extends Node2D

@export var speed : float

func _ready() -> void:
	Global.pause_game.emit()
	$Player.set_speed(speed)
