extends Control

var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " ", ".", ",", "-", "_", "'"]

var letter_id := 0

var on_time := 0.7
var off_time := 0.3

var on = false

func _on_up_pressed() -> void:
	letter_id += 1
	if letter_id > alphabet.size() - 1:
		letter_id = 0
	$Letter.text = alphabet[letter_id]

func _on_down_pressed() -> void:
	letter_id -= 1
	if letter_id < 0:
		letter_id = alphabet.size() - 1
	$Letter.text = alphabet[letter_id]

func _on_timer_timeout() -> void:
	if on:
		on = false
		$Timer.set_wait_time(on_time)
		$Letter.set_modulate(Color(1,1,1,0))
	else:
		on = true
		$Timer.set_wait_time(off_time)
		$Letter.set_modulate(Color(1,1,1,1))

func get_letter() -> String:
	return $Letter.text
