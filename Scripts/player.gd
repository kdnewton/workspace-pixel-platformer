extends Node

@onready var _character = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		_character.jump()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float):
	_character.run(Input.get_axis("run_left", "run_right"))
