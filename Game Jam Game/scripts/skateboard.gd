extends KinematicBody2D

const GRAVITY: float = 10.0
const FRICTION: float = 0.01
const MAX_SPEED: float = 200.0
const MIN_SPEED: float = 50.0

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta) -> void:
	velocity.y += GRAVITY

	# changing position
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	velocity = move_and_slide(velocity)

	velocity.x = lerp(velocity.x, 0, FRICTION)


func _on_Area2D_body_entered(body: Node) -> void:
	if body as Player:
		if abs(body.velocity.x) > abs(velocity.x):
			velocity.x = body.velocity.x
		else:
			velocity.x = MIN_SPEED * body.direction
			print(velocity.x, body.direction)
