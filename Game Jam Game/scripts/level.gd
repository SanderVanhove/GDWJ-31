extends Node2D
class_name Level

signal reached_door

export var show_tools: bool = true

onready var _player: Player = $player
onready var _door: Node2D = $door
onready var _end_timer: Timer = $end_timer


func _on_goal_finish() -> void:
	pass # Replace with function body.


func _on_door_body_entered(body: Node) -> void:
	if body as Player:
		_player.can_recieve_input = false
		_player.velocity.x = 300

		_end_timer.start()
		yield(_end_timer, "timeout")

		emit_signal("reached_door")
