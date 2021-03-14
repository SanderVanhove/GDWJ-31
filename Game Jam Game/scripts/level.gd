extends Node2D
class_name Level

signal finish

export var show_tools: bool = true

onready var _player: Player = $player
onready var _goal: StaticBody2D = $goal


func _on_goal_finish() -> void:
	pass # Replace with function body.

