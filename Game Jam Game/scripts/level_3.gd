extends Level


func _ready() -> void:
	_player.state = _player.states.NO_GRAVITY
	$dialog.play()
