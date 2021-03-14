extends AudioStreamPlayer2D
class_name RandomSoundPlayer

export(Array, String, FILE, "*.wav") var sounds

var _loaded_sounds: Array


func _ready() -> void:
	randomize()

	for sound in sounds:
		_loaded_sounds.append(load(sound))


func play_random_sound() -> void:
	stream = _loaded_sounds[rand_range(0, len(_loaded_sounds))]
	play()
