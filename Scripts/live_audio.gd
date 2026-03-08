extends VBoxContainer

@onready var volume_bar = $VolumeBar
@onready var volume_value = $VolumeValue

const MIN_DB: int = 100

var record_live_index: int
var volume_samples: Array
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance

var audio_mode := false

func _ready() -> void:
	volume_samples = []
	var devices = AudioServer.get_input_device_list()
	AudioServer.set_input_device(devices[0])
	record_live_index = AudioServer.get_bus_index('Record')
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_live_index, 1)
	var mode = Global.get_game_mode()
	if mode == Global.modes.BUTTON:
		audio_mode = false
		queue_free()
	else:
		audio_mode = true
		show()

func _physics_process(delta: float) -> void:
	if audio_mode:
		update_samples_strength()

func update_samples_strength() -> void:
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)
	while volume_samples.size() > 10:
		volume_samples.pop_back()
	var sample_avg = snapped(average_array(volume_samples) * 15, 0.01)
	if Global.game_state == Global.game_states.PLAY:
		if sample_avg > 0.7:
			volume_value.modulate = Color.GREEN
			Global.trigger_jump.emit()
		else:
			volume_value.modulate = Color.WHITE
	elif Global.game_state == Global.game_states.GAME_OVER:
		queue_free()
	else:
		volume_value.modulate = Color.WHITE
		sample_avg = 0
	volume_value.text = '%sdb' % min(1, sample_avg)
	volume_bar.value = min(1, sample_avg)

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
