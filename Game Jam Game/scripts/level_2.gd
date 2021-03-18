extends Level



func _ready() -> void:
	_player.input_map["up"] = 0

	$explanation_board.modulate.a = 0
	$Tween.interpolate_property($explanation_board, "modulate:a", 0, 1, 1)
	$Tween.interpolate_property($explanation_board, "scale", $explanation_board.scale * .9, $explanation_board.scale, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()


func _on_board_timer_timeout() -> void:
	$Tween.interpolate_property($explanation_board, "modulate:a", 1, 0, 1)
	$Tween.start()
