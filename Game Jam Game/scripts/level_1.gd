extends Level


onready var _timer: Timer = $Timer
onready var _pop_player: AudioStreamPlayer = $AudioStreamPlayer
onready var _dialog: Area2D = $dialog


func _ready() -> void:
	show_tools = false


func _on_dialog_body_entered(body: Node) -> void:
	if body as Player:
		_player.can_recieve_input = false
		_player.velocity = Vector2.ZERO
		
		_timer.start()

		yield(_timer, "timeout")

		_pop_player.play()
		_goal.hide()

		yield(_dialog, "done")

		emit_signal("finished")
