extends KinematicBody2D
class_name Player

# in case you forgot what up is
const UP = Vector2(0, -1)
const FRICTION = .25

# exports
export var movement_speed := 1
export var gravity := 10
export var jump_height := 400
export var max_speed := 200

# internal nodes
onready var _sprite: Sprite = $Sprite
onready var _raycast: RayCast2D = $RayCast2D
onready var _drop_shadow: Sprite = $Dropshadow

enum states {REGULAR, NO_GRAVITY}

# for messing with the inputs
var input_map = {"right": 1,
				 "left": -1,
				 "up": -1}

# go ahead and guess what this is
var velocity := Vector2()

# starting position
var starting_position = Vector2()

# state machine
var state = states.REGULAR

# direction the player is facing
var direction = 1

func _ready():
	starting_position = position

func _physics_process(delta):
	# resetting velocity

	# left and right movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += input_map.right * movement_speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x += input_map.left * movement_speed
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)

	# STATE MACHINEEEEE YOOOOOOOOOOOOOOOOOOOOOOOOOO
	match state:
		states.REGULAR:
			# gravity
			velocity.y += gravity

			# jumping
			if Input.is_action_just_pressed("ui_up"):
				if is_on_floor():
						velocity.y += input_map.up * jump_height
		# blowdryer code
#		states.NO_GRAVITY:

	# changing position
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	direction = -1 if velocity.x < 0 else 1
	_sprite.flip_h = velocity.x > 0

	velocity = move_and_slide(velocity, UP)

	position_drop_shadow()

func position_drop_shadow() -> void:
	_drop_shadow.position = to_local(_raycast.get_collision_point())

func _die():
	velocity.y = 0
	# death animation/particles or whatever
	position = starting_position

func _cactus_blow_back(pos):
	velocity += Vector2(sign(position.x - pos.x) * 300, -400)
