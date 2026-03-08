extends Node2D

var score : int
@export var punishment : int
@export var prize : int
@export var timer_wait : int
var starting_score : String = "0000000"
var bonus_sprite : Sprite2D
var initPos : Vector2
var endPos : Vector2
var modulate_color := Color.hex(0xfff29cff)

func _ready() -> void:
	bonus_sprite = $ScoreboardEffects/Sprite
	initPos = $ScoreboardEffects/InitPos.position
	endPos = $ScoreboardEffects/EndPos.position
	$Timer.set_wait_time(timer_wait)
	Global.unpause_game.connect(start)
	Global.pause_game.connect(stop)
	Global.scoreboard_add.connect(add)
	Global.scoreboard_rmv.connect(decrease)
	Global.end_game.connect(stop)

func start() -> void:
	update_score()
	$Timer.start()

func stop() -> void:
	$Timer.stop()

func update_score() -> void:
	var length = starting_score.length() - str(score).length()
	var s = ""
	for i in length:
		s+= "0"
	$ScoreLabel.text = s + str(score)

func decrease() -> void:
	if punishment > score:
		score = 0
	else:
		score += punishment
	update_score()

func add() -> void:
	score += prize
	bonus_anim()
	update_score()

func change_prize(new_val) -> void:
	prize = new_val

func change_punish(new_val) -> void:
	punishment = new_val

func increase_score() -> void:
	score += 5

func _on_timer_timeout() -> void:
	increase_score()
	update_score()

func bonus_anim():
	var tween = create_tween()
	tween.tween_property(bonus_sprite, "position", endPos, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(bonus_sprite, "modulate", modulate_color, 0.7)
	tween.tween_callback(reset)

func reset():
	bonus_sprite.set_modulate(Color(1,1,1,0))
	bonus_sprite.set_position(initPos)

func get_score() -> int:
	return score
