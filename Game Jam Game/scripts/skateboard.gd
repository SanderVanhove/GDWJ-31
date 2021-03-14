extends KinematicBody2D

const GRAVITY: float = 10.0
const FRICTION: float = 0.001
const MAX_SPEED: float = 200.0
const MIN_SPEED: float = 50.0

var velocity: Vector2 = Vector2.ZERO

var player = null

func _physics_process(delta) -> void:
	velocity.y += GRAVITY

	# changing position
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	if player != null:
		if player.item == player.items.BLOWDRYER:
			velocity.x += ODS.length_dir(1, player.get_node("blowdryer").rotation).x

	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)

	velocity.x = lerp(velocity.x, 0, FRICTION)

func _on_Area2D_body_entered(body: Node) -> void:
	if body as Player:
		if abs(body.velocity.x) > abs(velocity.x):
			velocity.x = body.velocity.x
		else:
			velocity.x = MIN_SPEED * body.direction
		player = body

func _on_Area2D_body_exited(body):
	if body as Player:
		player = null
