extends Node


onready var _inventory: Node2D = $inventory
onready var _room: Level = $room


func _ready() -> void:
	_inventory.visible = _room.show_tools
