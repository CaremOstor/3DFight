extends Area3D

@export var coin_cost: int = 1
var rotate_speed: float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(rotate_speed * delta)


func _on_body_entered(body):
	if body.name == 'Player':
		body.give_gold(coin_cost)
		
		# delete node from scene
		queue_free()
