extends Node

export(int) var amount_of_levels: int = 5
export(int, 1) var level_index: int = 1


onready var _inventory: Node2D = $inventory
onready var _level_holder: Node2D = $level_holder

var _room: Level


func _ready() -> void:
	load_level()

# Loads the level of the level_index
func load_level() -> void:
	# Remove last level
	if is_instance_valid(_room):
		_room.queue_free()

	var level_scene := load("res://levels/level_%d.tscn" % level_index)
	_room = level_scene.instance()
	_room.connect("reached_door", self, "load_next_level")

	_level_holder.add_child(_room)

	_inventory.visible = _room.show_tools


func load_next_level() -> void:
	level_index += 1

	# Check if there are still levels to be played
	if level_index <= amount_of_levels:
		load_level()
	else:
		get_tree().change_scene("res://menus/end_credits.tscn")
