extends KinematicBody2D

# in case you forgot what up is
const UP = Vector2(0, -1)

# exports
export var movement_speed := 100
export var gravity := 10
export var jump_height = 400

var velocity := Vector2()

# for messing with the inputs
var input_map = {"right": 1,
				 "left": -1,
				 "up": -1}

func _physics_process(delta):
	# gravity
	velocity.y += gravity
	
	# movement
	if Input.is_action_pressed("ui_right"):
		velocity.x = input_map.right * movement_speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = input_map.left * movement_speed
	else:
		velocity.x = 0
	
	# jumping
	if is_on_floor(): 
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = input_map.up * jump_height
	
	# changing position
	move_and_slide(velocity, UP)
