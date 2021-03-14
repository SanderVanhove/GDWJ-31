extends Node2D

onready var path_follow = get_parent()

export var speed := 1.5
var move_direction = 0

func _process(delta):
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed)
	var pos = path_follow.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / 3.14) * 180
