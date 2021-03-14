extends StaticBody2D


signal finish

onready var _particles: CPUParticles2D = $CPUParticles2D
onready var _audio: AudioStreamPlayer2D = $Audio

func _on_Area2D_body_entered(body: Node) -> void:
	if body as Player:
		_particles.emitting = true
		_audio.play()
		emit_signal("finish")
