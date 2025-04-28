extends StaticBody3D

@export var fall_time: float = 2.0  # Zeit, bis die Plattform fällt
var is_falling = false
var timer = 0.0

@onready var platform_mesh = $MeshInstance3D  # Das Mesh der Plattform
@onready var collision_shape = $CollisionShape3D  # Die Kollisionsform

# Timer starten, wenn der Spieler die Plattform betritt
func _on_Area3D_body_entered(body):
	if body is CharacterBody3D and !is_falling:
		# Starte den Falltimer
		timer = fall_time

func _process(delta):
	if is_falling:
		# Wenn die Plattform fällt, bewegen wir sie nach unten
		position.y -= delta * 5  # Geschwindigkeit des Fallens

		# Wenn die Plattform den Boden erreicht hat, deaktiviere sie
		if position.y < -20:
			queue_free()  # Zerstöre die Plattform, wenn sie den Boden erreicht
	else:
		# Zähle den Timer, wenn die Plattform warten soll
		if timer > 0:
			timer -= delta
		elif timer <= 0:
			# Wenn die Zeit um ist, beginne die Plattform zu fallen
			is_falling = true
