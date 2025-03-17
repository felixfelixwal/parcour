extends CharacterBody3D

var speed = 10
var sprint_speed = 20  # Increased speed when sprintingä
var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 10
var full_contact = false

var mouse_sensitivity = 0.03

var direction = Vector3()
var h_velocity = Vector3()
var gravity_vec = Vector3()

var is_sprinting = false  # Track if the player is sprinting

@onready var head = $Head
@onready var ground_check: RayCast3D = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	direction = Vector3()

	# Check if the raycast is colliding
	full_contact = ground_check.is_colliding()

	# Apply gravity
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration

	# Jump input handling
	if Input.is_action_just_pressed("jump") and (is_on_floor() or full_contact):
		gravity_vec = Vector3.UP * jump

	# Movement input handling
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	# Sprint input handlings
	is_sprinting = Input.is_action_pressed("sprint") and direction != Vector3.ZERO

	# Normalize direction and apply acceleration
	direction = direction.normalized()
	var current_speed = sprint_speed if is_sprinting else speed
	h_velocity = h_velocity.lerp(direction * current_speed, h_acceleration * delta)

	# Set the final velocity (gravity already accounted for in gravity_vec)
	velocity = Vector3(h_velocity.x, gravity_vec.y, h_velocity.z)

	# Use move_and_slide() with no arguments; it automatically uses the velocity
	move_and_slide()
