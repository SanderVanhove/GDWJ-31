extends Level


func _ready() -> void:
	_player.gravity = -10
	$dialog.play()
