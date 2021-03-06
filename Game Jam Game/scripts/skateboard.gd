extends KinematicBody2D

const GRAVITY: float = 10.0
const FRICTION: float = 0.001
const MAX_SPEED: float = 200.0
const MIN_SPEED: float = 100.0

onready var _audio: AudioStreamPlayer2D = $audio

var velocity: Vector2 = Vector2.ZERO

var player = null

func _physics_process(delta) -> void:
	velocity.y += GRAVITY

	# changing position
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	if player != null:
		if player.item == player.items.BLOWDRYER:
			velocity.x += ODS.length_dir(1, player.get_node("blowdryer").rotation).x

	# audio management
	if abs(velocity.x) > 1:
		if not _audio.playing and is_on_floor():
			_audio.play()
		_audio.volume_db = abs(velocity.x) / 10 - 7
	else:
		_audio.stop()

	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)

	velocity.x = lerp(velocity.x, 0, FRICTION)

func _on_Area2D_body_entered(body: Node) -> void:
	if body as Player:
		if abs(body.velocity.x) > abs(velocity.x):
			velocity.x = body.velocity.x
		else:
			velocity.x = MIN_SPEED * body.travel_direction
		player = body

func _on_Area2D_body_exited(body):
	if body as Player:
		player = null
