extends Node2D

var spawn_marker : Marker2D
@export var window_width : int = 640

@export var sprites : Array[Resource]

func _ready() -> void:
	spawn_marker = $Marker
	spawn_background()

func spawn_background():
	var count = 1
	var onScreen
	var respawnOnScreen
	var sprite_width
	var sprite_height
	while spawn_marker.position.x < window_width:
		var sprite = Sprite2D.new()
		sprite.texture = sprites.pick_random()
		sprite_width = sprite.texture.get_size().x
		sprite_height = sprite.texture.get_size().y
		onScreen = VisibleOnScreenNotifier2D.new()
		onScreen.position = spawn_marker.position + Vector2(sprite_width,0)
		onScreen.add_child(sprite)
		sprite.offset = Vector2(-sprite_width/2, -sprite_height/2) 
		onScreen.screen_exited.connect(onScreen.queue_free)
		spawn_marker.position.x += sprite_width
		count +=1
		add_child(onScreen)
	respawnOnScreen = VisibleOnScreenNotifier2D.new()
	respawnOnScreen.position -= Vector2(sprite_width, 0)
	respawnOnScreen.screen_entered.connect(spawn_background)
	onScreen.add_child(respawnOnScreen)
	window_width += spawn_marker.position.x
