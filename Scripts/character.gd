extends CharacterBody2D


@export_category("Locomotion")
@export var _speed : float = 8
@export var _acceleration : float = 16
@export var _deceleration : float = 32

@export_category("Jump")
@export var _jump_height : float = 2.5
@export var _air_control : float = 0.5
var _jump_velocity : float

@onready var _sprite : Sprite2D = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _direction : float

#region Public Methods

func face_left():
	_sprite.flip_h = true

func face_right():
	_sprite.flip_h = false

func run(direction : float):
	_direction = direction

func jump():
	if is_on_floor():
		velocity.y = _jump_velocity

func stop_jump():
	if velocity.y < 0:
		velocity.y = 0

#endregion

func _ready():
	_speed *= Global.pixels_per_tile
	_acceleration *= Global.pixels_per_tile
	_deceleration *= Global.pixels_per_tile
	_jump_height *= Global.pixels_per_tile
	_jump_velocity = sqrt(_jump_height * gravity * 2) * -1

func _physics_process(delta):
	if sign(_direction) == -1:
		face_left()
	elif sign(_direction) == 1:
		face_right()
	
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	move_and_slide()

func _ground_physics(delta : float):
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	elif velocity.x == 0 || sign(_direction) == sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration * delta)

func _air_physics(delta : float):
	velocity += get_gravity() * delta
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * _air_control * delta)
