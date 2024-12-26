extends CharacterBody2D


@export_category("Locomotion")
@export var _speed : float = 8
@export var _acceleration : float = 16
@export var _deceleration : float = 32

@export_category("Jump")
@export var _jump_height : float = 2.5
@export var _air_control : float = 0.5
@export var _jump_dust : PackedScene
var _jump_velocity : float

@export_category("Sprite")
@export var _is_facing_left : bool
@export var _sprites_face_left : bool
@onready var _sprite : Sprite2D = $Sprite2D
var _was_on_floor : bool

signal changed_direction(is_facing_left : bool)
signal landed(floot_height : float)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _direction : float

#region Public Methods

func face_left():
	_is_facing_left = true
	_sprite.flip_h = !_sprites_face_left
	changed_direction.emit(_is_facing_left)

func face_right():
	_is_facing_left = false
	_sprite.flip_h = _sprites_face_left
	changed_direction.emit(_is_facing_left)

func run(direction : float):
	_direction = direction

func jump():
	if is_on_floor():
		velocity.y = _jump_velocity
		_spawn_dust(_jump_dust)

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
	if _is_facing_left:
		face_left()
	else:
		face_right()

func _physics_process(delta):
	if !_is_facing_left && sign(_direction) == -1:
		face_left()
	elif _is_facing_left && sign(_direction) == 1:
		face_right()
	
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	
	_was_on_floor = is_on_floor()
	move_and_slide()
	if !_was_on_floor && is_on_floor():
		_landed()

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

func _landed():
	landed.emit(position.y)

func _spawn_dust(dust : PackedScene):
	var _dust = dust.instantiate()
	_dust.position = position
	_dust.flip_h = _sprite.flip_h
	get_parent().add_child(_dust)
	
