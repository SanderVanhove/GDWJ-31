extends Node2D


func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()

	rotate(get_angle_to(mouse_pos) + PI)
