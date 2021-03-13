extends RigidBody2D

signal blow_back(pos)


func _on_blow_back_area_body_entered(body):
	connect("blow_back", body, "_cactus_blow_back")
	emit_signal("blow_back", position)
	disconnect("blow_back", body, "_cactus_blow_back")
