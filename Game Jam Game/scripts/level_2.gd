extends Level

var played = false

func _ready() -> void:
	_player.input_map["up"] = 0
	_player.can_recieve_input = false
	$explanation_board.modulate.a = 0
	$Tween.interpolate_property($explanation_board, "modulate:a", 0, 1, 1)
	$Tween.interpolate_property($explanation_board, "scale", $explanation_board.scale * .9, $explanation_board.scale, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()


func _on_board_timer_timeout() -> void:
	$Tween.interpolate_property($explanation_board, "modulate:a", 1, 0, 1)
	$Tween.start()


func _on_Timer_timeout():
	_player.can_recieve_input = true

func _input(event):
	if event.is_pressed():
		if event.as_text() == "Up":
			if (!played):
				if ($dialog != null):
					$dialog.queue_free()
				$nice_job.play()
				$Timer.stop()
				_player.can_recieve_input = true
				played = true

func _on_pause_timer_timeout():
	$good_luck.play()

func _on_nice_job_finished():
	$pause_timer.start()
