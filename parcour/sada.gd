extends StaticBody3D

# This function is called when another body enters the collision area
func _on_body_entered(body: Node3D):
	# Check if the body that entered is the player
	if body.is_in_group("player"):
		# Reset the player's position to their origin
		body.global_transform.origin = body.initial_position
