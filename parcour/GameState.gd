extends Area3D

@export var checkpoint_position: Node3D

func _on_body_entered(body):
	if body is CharacterBody3D:
		if "set_spawn_point" in body:
			body.set_spawn_point(checkpoint_position)
