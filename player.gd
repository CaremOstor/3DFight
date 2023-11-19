extends CharacterBody3D

var damage: int = 1
var attack_rate: float = 0.3
var _last_attack_time: int = 0

var gold: int = 0
var HP = {
	'current': 10, 
	'max': 10,
}

const SPEED = 10.0
const JUMP_VELOCITY = 9.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var AttackRayCast = get_node("AttackRayCast")
@onready var SwordAnimator: AnimationPlayer = get_node("WeaponHolder/SwordAnimator")
@onready var UI: Control = get_node("/root/MainScene/CanvasLayer/UI")


func _ready():
	UI.update_hp_bar(HP)
	UI.update_gold(gold)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("attack"):
		try_attack()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func give_gold(amount):
	gold += amount
	UI.update_gold(gold)
	
func take_damage(dmg):
	HP['current'] -= dmg
	UI.update_hp_bar(HP)
	
	if HP['current'] <= 0: 
		get_tree().reload_current_scene()# GAME OVER!

func try_attack():
	if Time.get_ticks_msec() - _last_attack_time < attack_rate * 1000:
		return
	_last_attack_time = Time.get_ticks_msec()
	SwordAnimator.stop()
	SwordAnimator.play('attack', -1, 0.5)
	if SwordAnimator.is_playing():
		print('playing')
	else:
		print('not playing')
	if AttackRayCast.is_colliding():
		if AttackRayCast.get_collider().has_method('take_damage'):
			AttackRayCast.get_collider().take_damage(damage)
