extends Area2D

signal done

export(Array, String, MULTILINE) var text: Array
export(Array, AudioStream) var audio_stream: Array


onready var _voice_audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _label: Label = $CanvasLayer/Label
onready var _tween: Tween = $Tween

var playing: bool = false


func _on_dialog_body_entered(body: Node) -> void:
	if not body as Player:
		return

	play()

func play():
	if playing:
		return

	playing = true

	for i in range(len(text)):
		_label.text = text[i]
		_voice_audio.stream = audio_stream[i]

		_voice_audio.play()

		_tween.interpolate_property(_label, "modulate:a", 0, 1, .5)
		_tween.start()

		yield(_voice_audio, "finished")

		_tween.interpolate_property(_label, "modulate:a", 1, 0, 1, 0, 2)
		_tween.start()

		yield(_tween, "tween_all_completed")

	emit_signal("done")

	queue_free()
