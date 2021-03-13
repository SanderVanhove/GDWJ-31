extends Node

func length_dir(length: int, angle: float):
	var final: = Vector2()
	final.x = length * cos(angle)
	final.y = length * sin(angle)
	return final

func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func pick(values: Array):
	return values[randi() % values.size()]
