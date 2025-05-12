extends CharacterBody3D

@export var fall_time: float = 2.0  # Zeit, bis die Plattform fällt
var is_falling = false
var timer = 0.0


@onready var platform_mesh = $".."
@onready var collision_shape = $CollisionShape3D  # Die Kollisionsform

# Timer starten, wenn der Spieler die Plattform betritt
func _on_area3D_body_entered(body):
	if body is CharacterBody3D and !is_falling:
		# Starte den Falltimer
		timer = fall_time

func _physics_process(delta):
	if is_falling:
		print("Plattform fällt jetzt")
	# setze vertikale Geschwindigkeit
		velocity = Vector3(0, -5, 0)
	# lasse den CharacterBody3D fallen und Kollisionen prüfen
	move_and_slide()
	if global_transform.origin.y < -20:
		queue_free()

	else:
		# Zähle den Timer, wenn die Plattform warten soll
		if timer > 0:
			print("Timer läuft: ", timer)
			timer -= delta
		elif timer <= 0:
			# Wenn die Zeit um ist, beginne die Plattform zu fallen
			is_falling = true


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D and !is_falling:
		print("Checkpoint: Spieler auf Plattform—starte Timer")
		timer = fall_time
