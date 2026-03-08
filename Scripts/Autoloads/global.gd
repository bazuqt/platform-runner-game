extends Node

@warning_ignore("unused_signal")
signal spawn_remote()
@warning_ignore("unused_signal")
signal stop_spawn()
@warning_ignore("unused_signal")
signal resume_spawn()
@warning_ignore("unused_signal")
signal speed_bumped()

@warning_ignore("unused_signal")
signal enable_player_cam()

@warning_ignore("unused_signal")
signal in_main_menu_buttons()
@warning_ignore("unused_signal")
signal out_main_menu_buttons()

signal pause_game()
signal unpause_game()

@warning_ignore("unused_signal")
signal start_scoreboard()
@warning_ignore("unused_signal")
signal stop_scoreboard()
@warning_ignore("unused_signal")
signal scoreboard_add()
@warning_ignore("unused_signal")
signal scoreboard_rmv()

@warning_ignore("unused_signal")
signal run_animation()
@warning_ignore("unused_signal")
signal idle_animation()

@warning_ignore("unused_signal")
signal marker_position()

@warning_ignore("unused_signal")
signal trigger_jump()

@warning_ignore("unused_signal")
signal disable_vertical_parallax()

signal set_mode(mode)

@warning_ignore("unused_signal")
signal parkour_cam
@warning_ignore("unused_signal")
signal normal_cam

@warning_ignore("unused_signal")
signal get_player_score()

signal end_game()

var game_state
var current_mode = Global.modes.BUTTON

var player_position : float = 75.0

func _ready() -> void:
	pause_game.connect(pause)
	unpause_game.connect(unpause)
	end_game.connect(game_over)
	set_mode.connect(set_game_mode)

func pause():
	print("game paused")
	set_gamestate(Global.game_states.PAUSE)

func unpause():
	print("game unpaused")
	set_gamestate(Global.game_states.PLAY)

func game_over():
	print("game over")
	set_gamestate(Global.game_states.GAME_OVER)

func set_gamestate(new_gamestate: Global.game_states ) -> void:
	game_state = new_gamestate

func update_player_position(new_player_position):
	player_position = new_player_position

func set_game_mode(new_mode : Global.modes) -> void:
	current_mode = new_mode

func get_game_mode() -> Global.modes:
	return current_mode

enum game_states {
	PLAY,
	PAUSE,
	GAME_OVER,
}

enum modes {
	VOICE,
	BUTTON
}
