extends Node2D

var is_on: bool = false

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var rot_offset: float = 0 if $Sprite.flip_h else PI
	rotate(get_angle_to(mouse_pos) + rot_offset)

func turn_on() -> void:
	if is_on:
		return

	is_on = true

	$turn_on.play()

	yield($turn_on, "finished")

	if is_on:
		$loop.play()

func turn_off() -> void:
	if not is_on:
		return

	is_on = false
	$turn_on.stop()
	$loop.stop()
