extends Area2D


func _on_door_body_entered(body: Node) -> void:
	if not body as Player:
		return

	$AudioStreamPlayer2D.play()
