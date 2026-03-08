extends AudioStreamPlayer2D

@export var main_melody : AudioStreamMP3
@export var repeat_melody : AudioStreamMP3
var main_finished := false

func _ready() -> void:
	set_stream(main_melody)
	play()

func _on_finished() -> void:
	if not main_finished:
		main_finished = true
		set_stream(repeat_melody)
	play()

func change_music(new_track):
	set_stream(new_track)
	play()

func return_music():
	main_finished = false
	set_stream(main_melody)
	play()
