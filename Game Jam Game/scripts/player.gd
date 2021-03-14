extends KinematicBody2D
class_name Player

# in case you forgot what up is
const UP = Vector2(0, -1)
const FRICTION = .25

# exports
export var movement_speed := 1500
export var gravity := 10
export var jump_height := 400
export var max_speed := 200

# internal nodes
onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _raycast: RayCast2D = $RayCast2D
onready var _drop_shadow: Sprite = $Dropshadow

enum states {REGULAR, NO_GRAVITY}
enum items {NONE, MAGNET, BLOWDRYER}

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
var item = items.NONE

# direction the player is facing
var direction = 1

# last selected update variable
var last_selected = gg.selected
var current_items = []

func _ready():
	starting_position = position

func _process(delta):
	if gg.selected != last_selected:
		match gg.selected:
			1:
				var inst = load("res://scenes/cactus.tscn").instance()
				inst.position = position + Vector2(sign(position.x - get_viewport().get_mouse_position().x) * 50, 24)
				get_parent().add_child(inst)
				current_items.append(inst)
			2:
				var inst = load("res://scenes/skateboard.tscn").instance()
				if _drop_shadow.position.distance_to(position) > 100:
					inst.position = position + Vector2(0, 40)
				get_parent().add_child(inst)
				current_items.append(inst)
			3:
				item = items.BLOWDRYER
			4:
				item = items.MAGNET
			0:
				item = items.NONE
		last_selected = gg.selected

func _physics_process(delta):
	# resetting velocity

	# jumping
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y += input_map.up * jump_height

	# STATE MACHINEEEEE YOOOOOOOOOOOOOOOOOOOOOOOOOO
	match state:
		states.REGULAR:
			# gravity
			velocity.y += gravity
				# left and right movement
			if Input.is_action_pressed("ui_right"):
				velocity.x += input_map.right * movement_speed * delta
				direction = 1
			elif Input.is_action_pressed("ui_left"):
				velocity.x += input_map.left * movement_speed * delta
				direction = -1
			else:
				if is_on_floor():
					velocity.x = lerp(velocity.x, 0, FRICTION)

		states.NO_GRAVITY:
			# setting the movement speed for the different objects in zero grav
			var move_factor = 0.80
			if item == items.NONE or item == items.BLOWDRYER:
				move_factor = 0.01

			if Input.is_action_pressed("ui_right"):
				velocity.x += input_map.right * (movement_speed * move_factor)
				direction = 1
			elif Input.is_action_pressed("ui_left"):
				velocity.x += input_map.left * (movement_speed * move_factor)
				direction = -1
			else:
				if is_on_floor():
					velocity.x = lerp(velocity.x, 0, FRICTION)

	update_animation()

	# item state machine
	match item:
		items.NONE:
			$blowdryer.hide()
			$magnet.hide()
		items.MAGNET:
			$blowdryer.hide()
			$magnet.show()
			velocity.y += 50
		items.BLOWDRYER:
			$blowdryer.show()
			$magnet.hide()
#			if state != states.REGULAR:
			velocity += ODS.length_dir(1, $blowdryer.rotation)

	# clamping speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	# determining direction
	_sprite.flip_h = direction == 1
	$blowdryer.position.x = 10 * direction
	$magnet.position.x = 10 * direction

	velocity = move_and_slide(velocity, UP, false, 4, PI / 4, false)

	position_drop_shadow()

func update_animation() -> void:
	var animation = "idle"

	if state == states.REGULAR or state == states.NO_GRAVITY:
		if is_on_floor():
			if (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
				animation = "run"

		else:
			animation = "jump"

	if item != items.NONE:
		animation += "-hold"

	_sprite.play(animation)

func position_drop_shadow() -> void:
	_drop_shadow.position = to_local(_raycast.get_collision_point())

func _die():
	velocity.y = 0
	# death animation/particles or whatever
	position = starting_position

func _cactus_blow_back(pos):
	velocity.x = sign(position.x - pos.x) * 200
	velocity.y = -1 * jump_height
