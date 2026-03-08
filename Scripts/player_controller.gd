extends CharacterBody2D

@export var speed := 100
@export var MAX_SPEED := 500
@export var JUMP_SPEED := -400
var is_jumping := false

var action_window : bool = false
var action_result : bool = false
var current_obstacle : Area2D

@export_category("Sound")
@export var pause_music : AudioStreamMP3
@export var jump_effect : AudioStreamMP3
@export var bonus_effect : AudioStreamMP3
@export var gameo_effect : AudioStreamMP3

var offset_cam = Vector2(245, -106)
var parkour_cam = Vector2(245, 0)

func _ready() -> void:
	Global.enable_player_cam.connect($Camera.set_enabled.bind(true))
	Global.run_animation.connect(start_running_animation)
	Global.idle_animation.connect(start_idle_animation)
	Global.trigger_jump.connect(jump)
	Global.marker_position.connect(give_position)
	Global.end_game.connect(game_over_player)
	Global.normal_cam.connect(return_cam)
	Global.parkour_cam.connect(change_cam)
	Global.get_player_score.connect(send_score)
	$UI/PauseMenu.get_node("ResumeCounter").resume_signal.connect(resume_game)
	start_idle_animation()

func set_speed(new_speed : int) -> void:
	speed = new_speed

func start_running_animation():
	$Sprite.play("Run", 2)

func start_idle_animation():
	$Sprite.play("Idle", 2)

func stop_animation():
	$Sprite.pause()

func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and Global.game_state == Global.game_states.PLAY:
		pause_menu()
		stop_animation()
	if Input.is_action_just_pressed("Jump"):
		if Global.get_game_mode() == Global.modes.BUTTON:
			$Sprite.play("Run", 0.2)
			jump()
	if Global.game_state == Global.game_states.PAUSE:
		velocity = Vector2.ZERO
	elif Global.game_state == Global.game_states.GAME_OVER:
		velocity = Vector2.ZERO
	else:
		start_running_animation()
		if not is_on_floor():
			velocity += get_gravity() * delta
			is_jumping = false
		elif is_jumping and is_on_floor():
			$SoundEfects.play_sound(jump_effect)
			if action_window:
				success()
			velocity.y = JUMP_SPEED
			is_jumping = false
		velocity.x = min(speed, MAX_SPEED)
	move_and_slide()

func jump():
	is_jumping = true

func increase_speed():
	speed += 100

func _on_hitbox_area_entered(area: Area2D) -> void:
	match area.collision_layer:
		2:
			fail()
		4:
			action_window = true
			current_obstacle = area

func _on_hitbox_area_exited(_area: Area2D) -> void:
	action_window = false

func success():
	$SoundEfects.play_sound(bonus_effect)
	$PlayerEffects.success_anim()
	$Scoreboard.bonus_anim()
	Global.scoreboard_add.emit()
	current_obstacle.deactivate()

func fail():
	Global.scoreboard_rmv.emit()
	Global.end_game.emit()

func give_position():
	Global.update_player_position(position.x + $ObstacleSpawn.position.x)

func pause_menu():
	$LevelMusic.set_stream(pause_music)
	$LevelMusic.play()
	Global.pause_game.emit()
	%PauseMenu.in_menu()
	%PauseMenu.show()

func resume_game():
	$LevelMusic.return_music()
	Global.unpause_game.emit()
	%PauseMenu.hide()

func send_score():
	ScoreManager.set_last_score($Scoreboard.get_score())

func game_over_player():
	stop_animation()
	$SoundEfects.play_sound(gameo_effect)
	$LevelMusic.stop()
	

func change_cam():
	var tween = create_tween()
	tween.tween_property($Camera, "offset", parkour_cam, 0.5).set_ease(Tween.EASE_IN_OUT)

func return_cam():
	var tween = create_tween()
	tween.tween_property($Camera, "offset", offset_cam, 0.3).set_ease(Tween.EASE_IN_OUT)
