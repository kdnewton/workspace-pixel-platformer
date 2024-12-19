extends CharacterBody2D


const JUMP_VELOCITY = -400.0
@export var _speed : float = 8
@export var _acceleration : float = 16
@export var _deceleration : float = 32

var _direction : float

#region Public Methods

func face_left():
	pass

func face_right():
	pass

func run(direction : float):
	_direction = direction

func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
#endregion

func _ready():
	_speed *= Global.pixels_per_tile
	_acceleration *= Global.pixels_per_tile
	_deceleration *= Global.pixels_per_tile

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	elif velocity.x == 0 || sign(_direction) == sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration * delta)
		

	move_and_slide()
