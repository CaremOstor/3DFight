extends CharacterBody3D

var damage: int = 1
var attack_rate: float = 1.0
var attack_distance: float = 1.5 
var player_is_higher: bool = false
var HP = {
	'current': 3, 
	'max': 3,
}

const SPEED = 5.0
const JUMP_VELOCITY = 18.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var timer: Timer = get_node("Timer")
@onready var player: CharacterBody3D = get_node('/root/MainScene/Player')

func _ready():
	timer.wait_time = attack_rate
	timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


	var distance: float = position.distance_to(player.position)
	if distance > attack_distance:
		var direction = (player.position - position).normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		move_and_slide()

func _on_timer_timeout():

	var distance: float = position.distance_to(player.position)
	if distance > attack_distance:
		var direction = (player.position - position).normalized()
		velocity.y = direction.y * JUMP_VELOCITY

	if position.distance_to(player.position) <= attack_distance:
		player.take_damage(damage)

func take_damage(dmg):
	HP['current'] -= dmg
	if HP['current'] <= 0: 
		queue_free() # DIE! 
	
