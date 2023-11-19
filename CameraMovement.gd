extends Node3D

const LOOK_SENSIVITY = 5.0
const LOOK_ANGLE = {
	'min': -60.0,
	'max': 0.0,
}

var mouse_delta: Vector2
var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player  = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and MOUSE_BUTTON_LEFT:
		mouse_delta = event.relative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_rotation: Vector3 = Vector3(
		mouse_delta.y,
		mouse_delta.x,
		0
	) * LOOK_SENSIVITY * delta
	
	# clamp(x, 1, 10) - if x > 10 return 10, if x < 1 return 1, else return x
	rotation_degrees.x -= player_rotation.x
	rotation_degrees.x = clamp(rotation_degrees.x, LOOK_ANGLE['min'], LOOK_ANGLE['max'])
	player.rotation_degrees.y -= player_rotation.y 
	
	mouse_delta = Vector2()
	
		
