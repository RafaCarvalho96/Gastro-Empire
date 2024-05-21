extends CharacterBody3D
class_name Player

const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var inv: Inventory
@export var attachable: Attachable
@onready var camera_pivot = $CameraPivot

var activeArea: InteractiveArea

var sprintCooldown = false
var sprintActive = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP,camera_pivot.rotation.y)
	
	if direction != Vector3.ZERO:
		$Pivot.basis = Basis.looking_at(direction.normalized())
	
	if Input.is_action_pressed("move_stop"):
		return
	
	direction = direction.normalized()
	var speedToApply = SPEED
	if Input.is_action_pressed("move_sprint"):
		if not sprintCooldown:
			speedToApply *= 2.5
			if not sprintActive:
				sprintActive = true
				var timer = get_tree().create_timer(1)
				timer.timeout.connect(_init_sprint_cooldown)
	
	if direction:
		velocity.x = direction.x * speedToApply
		velocity.z = direction.z * speedToApply
	else:
		velocity.x = move_toward(velocity.x, 0, speedToApply)
		velocity.z = move_toward(velocity.z, 0, speedToApply)
	
	move_and_slide()


func _init_sprint_cooldown():
	sprintActive = false
	sprintCooldown = true
	var timer = get_tree().create_timer(2)
	timer.timeout.connect(_on_sprint_cooldown_reset)


func _on_sprint_cooldown_reset():
	sprintCooldown = false
