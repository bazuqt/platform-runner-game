extends AudioStreamPlayer2D

@export var hover_sound_effects : Array[AudioStreamMP3]
@export var start_game_effect : AudioStreamMP3
@export var button_sound_effect : AudioStreamMP3

func play_hover_effect():
	var index = randi_range(0,hover_sound_effects.size()-1)
	set_stream(hover_sound_effects[index])
	play()

func play_start_game_click_effect():
	set_stream(start_game_effect)
	play()

func play_button_clicked_effect():
	set_stream(button_sound_effect)
	play()

func play_sound(sound : AudioStreamMP3):
	set_stream(sound)
	play()
