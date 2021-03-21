extends Level


func _ready() -> void:
	_player.input_map["right"] = -1
	$dialog.play()


func _on_goal_finishwd() -> void:
	_end_timer.start()
	yield(_end_timer, "timeout")

	emit_signal("reached_door")
