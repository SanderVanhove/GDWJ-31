extends Node2D


onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _process(delta: float) -> void:
	if visible and not audio.playing:
		audio.play()
	elif not visible:
		audio.stop()
