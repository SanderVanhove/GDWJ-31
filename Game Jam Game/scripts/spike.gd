extends Area2D

signal die

func _on_spike_body_entered(body):
	connect("die", body, "_die")
	emit_signal("die")
	disconnect("die", body, "_die")
