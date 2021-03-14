extends Level


onready var _goal: Node2D = $goal
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
		_goal.queue_free()

		yield(_dialog, "done")

		_player.can_recieve_input = true

		_pop_player.play()
		$TileMap.queue_free()
		$TileMap2.show()
		$TileMap2.set_collision_layer_bit(0, true)
		$door.show()
