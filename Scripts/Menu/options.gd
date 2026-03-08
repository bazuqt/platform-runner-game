extends Control

var init_pos : Vector2
var end_pos : Vector2

@export var test_sound : AudioStreamMP3
@export var show_mode_change := true

func _ready() -> void:
	init_pos = $InitPos.position
	end_pos = $EndPos.position
	if show_mode_change:
		var mode = Global.get_game_mode()
		match mode:
			Global.modes.VOICE:
				$OptionsButtons/OptionStack/Mode.set_pressed(true)
			Global.modes.BUTTON:
				$OptionsButtons/OptionStack/Mode.set_pressed(false)
		$OptionsButtons/OptionStack/Mode.set_disabled(false)
		$OptionsButtons/OptionStack/Mode.show()
	else:
		$OptionsButtons/OptionStack/Mode.set_disabled(true)
		$OptionsButtons/OptionStack/Mode.hide()
	init_values()

func init_values():
	var music_i = AudioServer.get_bus_index('Music')
	var effec_i = AudioServer.get_bus_index('Effects')
	var music = AudioServer.get_bus_volume_db(music_i)
	var effects = AudioServer.get_bus_volume_db(effec_i)
	var music_m = AudioServer.is_bus_mute(music_i)
	var effec_m = AudioServer.is_bus_mute(effec_i)
	%MuteVolume.set_pressed(music_m)
	%MuteEffects.set_pressed(effec_m)
	%VolumeLabel.text = rectify_value(music)
	%EffectsLabel.text = rectify_value(effects)
	%VolumeSlider.value = music
	%SFXSlider.value = effects

func _on_mode_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.set_mode.emit(Global.modes.VOICE)
	else:
		Global.set_mode.emit(Global.modes.BUTTON)

func _on_volume_slider_value_changed(value: float) -> void:
	var index = AudioServer.get_bus_index('Music')
	if not AudioServer.is_bus_mute(index):
		AudioServer.set_bus_volume_db(index, value)
		%VolumeLabel.text = rectify_value(value)

func _on_mute_volume_toggled(toggled_on: bool) -> void:
	var index = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_mute(index, toggled_on)
	%VolumeSlider.set_scrollable(not toggled_on)

func _on_sfx_slider_value_changed(value: float) -> void:
	var index = AudioServer.get_bus_index('Effects')
	if not AudioServer.is_bus_mute(index):
		%EffectsLabel.text = rectify_value(value)
		$Effects.play_sound(test_sound)
		AudioServer.set_bus_volume_db(index, value)

func _on_mute_effects_toggled(toggled_on : bool) -> void:
	var index = AudioServer.get_bus_index('Effects')
	AudioServer.set_bus_mute(index, toggled_on)
	%SFXSlider.set_scrollable(not toggled_on)

func rectify_value(value):
	return str(round((value + 20) / 3))

func _on_back_pressed() -> void:
	Global.in_main_menu_buttons.emit()
	out_options()

func out_options():
	%Back.set_disabled(true)
	var tween = create_tween()
	tween.tween_property($OptionsButtons, "position", init_pos, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(hide)

func in_options():
	show()
	var tween = create_tween()
	tween.tween_property($OptionsButtons, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($OptionsButtons, "position", end_pos, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(enable_button)

func enable_button():
	%Back.set_disabled(false)
