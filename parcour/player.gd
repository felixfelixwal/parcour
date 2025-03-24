extends CharacterBody3D

var speed = 10
var sprint_speed = 16 
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

var is_sprinting = false

@onready var head = $Head
@onready var ground_check: RayCast3D = $GroundCheck
@onready var spawn_point: Marker3D = $"../Map/SpawnPoint"
@onready var camera: Camera3D = $Head/Camera3D


var fall_threshold: float = -10.0
var min_fov = 70 
var max_fov = 90  
var fov_smooth_speed = 5.0  

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	direction = Vector3()

	if global_transform.origin.y < fall_threshold:
		reset_player()
		return 


	full_contact = ground_check.is_colliding()

	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration

	if Input.is_action_just_pressed("jump") and (is_on_floor() or full_contact):
		gravity_vec = Vector3.UP * jump

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	is_sprinting = Input.is_action_pressed("sprint") and direction != Vector3.ZERO

	direction = direction.normalized()
	var current_speed = sprint_speed if is_sprinting else speed
	h_velocity = h_velocity.lerp(direction * current_speed, h_acceleration * delta)

	velocity = Vector3(h_velocity.x, gravity_vec.y, h_velocity.z)

	move_and_slide()

	adjust_fov(current_speed)

func adjust_fov(current_speed: float):
	var target_fov = min_fov + ((current_speed - speed) / (sprint_speed - speed)) * (max_fov - min_fov)
	target_fov = clamp(target_fov, min_fov, max_fov)
	camera.fov = lerp(camera.fov, target_fov, fov_smooth_speed * get_process_delta_time())

func reset_player():
	if spawn_point:
		global_transform.origin = spawn_point.global_transform.origin
		velocity = Vector3.ZERO
		gravity_vec = Vector3.ZERO
	else:
		print("Spawn point not assigned!")
	
