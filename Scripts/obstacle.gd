extends Area2D

var spawnMarker : Marker2D
var pointsCollision : CollisionShape2D
var hitboxCollision : CollisionShape2D

@export_category("Resources")
@export var moving_speed : Array[float]
@export var plays_sound : Array[bool]
@export var sounds : Array[AudioStreamMP3]
@export var sprite_frames : Array[SpriteFrames]
#size [x, y] position [z, w]
@export var ph_values : Array[Vector4]
@export var hb_values : Array[Vector4]

@export var transforms : Array[Transform2D]
var selected : int
var speed : float
var sound : bool
var play_sound : AudioStreamMP3

func _ready() -> void:
	pointsCollision = $PointsHitbox
	hitboxCollision = $Hitbox/Hitbox
	selected = randi_range(0, sprite_frames.size() - 1)
	initialize_object()

func initialize_object():
	
	pointsCollision.shape = RectangleShape2D.new()
	hitboxCollision.shape = RectangleShape2D.new()
	speed = moving_speed[selected]
	$Sprite.set_sprite_frames(sprite_frames[selected])
	$Sprite.play("default")
	var size = Vector2(ph_values[selected].x, ph_values[selected].y)
	var pos = Vector2(ph_values[selected].z, ph_values[selected].w)
	pointsCollision.shape.set_size(size)
	pointsCollision.position = pos
	size = Vector2(hb_values[selected].x, hb_values[selected].y)
	pos = Vector2(hb_values[selected].z, hb_values[selected].w)
	hitboxCollision.shape.set_size(size)
	hitboxCollision.position = pos
	$Sprite.set_transform(transforms[selected])
	sound = plays_sound[selected]
	if sound:
		play_sound = sounds[selected]

func _physics_process(delta: float) -> void:
	if Global.game_state == Global.game_states.PAUSE:
		$Sprite.stop()
		$Audio.stop()
	elif Global.game_state == Global.game_states.PLAY:
		$Sprite.play("default")
		position.x -= speed * delta
		if sound and not $Audio.is_playing():
			$Audio.set_stream(play_sound)
			$Audio.play()
	elif Global.game_state == Global.game_states.GAME_OVER:
		$Sprite.play("game_over")
		$Audio.stop()

func deactivate():
	hitboxCollision.set_disabled(true)
	pointsCollision.set_disabled(true)

func _on_on_screen_screen_exited() -> void:
	queue_free()
