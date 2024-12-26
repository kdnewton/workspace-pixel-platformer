extends Camera2D

@export var _subject : Node2D
@export var _offset : Vector2
@onready var _look_ahead_distance : float = _offset.x

func _ready():
	_offset *= Global.pixels_per_tile

func _process(_delta : float):
	position.x = _subject.position.x + _look_ahead_distance

func _on_subject_changed_direction(is_facing_left : bool):
	_look_ahead_distance = _offset.x * (-1 if is_facing_left else 1)

func _on_subject_landed(floor_height : float):
	position.y = floor_height + _offset.y
