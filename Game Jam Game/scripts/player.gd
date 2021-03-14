extends KinematicBody2D
class_name Player

# in case you forgot what up is
const UP = Vector2(0, -1)
const FRICTION = .25
const AIR_FRICTION = .98

# exports
export var movement_speed := 1500
export var gravity := 10
export var jump_height := 300
export var max_speed := 200
export var can_recieve_input: bool = true

# internal nodes
onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _raycast: RayCast2D = $RayCast2D
onready var _drop_shadow: Sprite = $Dropshadow
onready var _jump_player: RandomSoundPlayer = $jump_player
onready var _damage_player: RandomSoundPlayer = $damage_player
onready var _footstep_player: RandomSoundPlayer = $footstep_player
onready var _footstep_timer: Timer = $footstep_timer
onready var _land_player: RandomSoundPlayer = $land_player
onready var _pop_player: RandomSoundPlayer = $pop_player
onready var _cactus_sting_player: RandomSoundPlayer = $cactus_sting_player

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

# wether the player was in the air last update
var was_in_air: bool = true

func _ready():
	starting_position = position

func _process(delta):
	if gg.selected != last_selected:
		match gg.selected:
			1:
				for i in current_items:
					if i.name.substr(0, 6) == "cactus":
						i.queue_free()
						current_items.remove(current_items.find(i))
				var inst = load("res://scenes/cactus.tscn").instance()
				inst.position = position + Vector2(sign(position.x - get_global_mouse_position().x) * 26, 24)
				inst.name = "cactus"
				get_parent().add_child(inst, true)
				current_items.append(inst)

				_pop_player.play_random_sound()
			2:
				for i in current_items:
					if i.name.substr(0, 10) == "skateboard":
						i.queue_free()
						current_items.remove(current_items.find(i))
				var inst = load("res://scenes/skateboard.tscn").instance()
				if _drop_shadow.position.distance_to(position) > 50:
					inst.position = position + Vector2(0, 50)
				inst.name = "skateboard"
				inst.velocity = velocity
				get_parent().add_child(inst, true)
				current_items.append(inst)

				_pop_player.play_random_sound()
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
	if Input.is_action_just_pressed("ui_up") and can_recieve_input:
		if is_on_floor():
			velocity.y += input_map.up * jump_height
			_jump_player.play_random_sound()

	var move_factor = 1
	# STATE MACHINEEEEE YOOOOOOOOOOOOOOOOOOOOOOOOOO
	match state:
		states.REGULAR:
			# gravity
			velocity.y += gravity
		states.NO_GRAVITY:
			# setting the movement speed for the different objects in zero grav
			move_factor = 0.80
			if item == items.NONE or item == items.BLOWDRYER:
				move_factor = 0.01

	if Input.is_action_pressed("ui_right") and can_recieve_input:
		velocity.x += input_map.right * (movement_speed * move_factor)
		direction = 1
	elif Input.is_action_pressed("ui_left") and can_recieve_input:
		velocity.x += input_map.left * (movement_speed * move_factor)
		direction = -1
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0, FRICTION)
		else:
			velocity.x *= AIR_FRICTION

	update_animation()

	# item state machine
	match item:
		items.NONE:
			$blowdryer.hide()
			$blowdryer.turn_off()
			$magnet.hide()
		items.MAGNET:
			$blowdryer.hide()
			$blowdryer.turn_off()
			$magnet.show()
			velocity.y += 50
		items.BLOWDRYER:
			$blowdryer.show()
			$blowdryer.turn_on()
			$magnet.hide()
#			if state != states.REGULAR:
			var rot_offset = PI if direction == 1 else 0
			velocity += ODS.length_dir(1, $blowdryer.rotation + rot_offset)

	# clamping speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	# determining direction
	_sprite.flip_h = direction == 1
	$blowdryer.position.x = 10 * direction
	$magnet.position.x = 10 * direction
	$blowdryer/Sprite.flip_h = direction == 1

	velocity = move_and_slide(velocity, UP, false, 4, PI / 4, false)

	handle_footstep_sound()

	position_drop_shadow()
	was_in_air = not is_on_floor()

func handle_footstep_sound() -> void:
	if not is_on_floor():
		return

	if was_in_air:
		_land_player.play_random_sound()
	elif (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) and not _footstep_timer.time_left:
		_footstep_player.play_random_sound()
		_footstep_timer.start()

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
	_damage_player.play_random_sound()

func _cactus_blow_back(pos):
	velocity.x = sign(position.x - pos.x) * 200
	velocity.y = -1 * jump_height

	_cactus_sting_player.play_random_sound()
