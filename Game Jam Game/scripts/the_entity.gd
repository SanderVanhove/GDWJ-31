extends Node2D

onready var path_follow = get_parent()

export var speed := 1.5
var move_direction = 0
var active = true setget activated

func _ready():
	modulate.a = 0.5

func _process(delta):
	if (active != gg.entity_active):
		self.active = gg.entity_active
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed)
	var pos = path_follow.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / 3.14) * 180

func activated(value):
	active = value
	if active:
		$active.interpolate_property(self, "modulate:a", modulate.a, 1, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	else:
		$active.interpolate_property(self, "modulate:a", modulate.a, 0.5, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	$active.start()
