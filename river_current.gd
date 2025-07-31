extends Area2D
# Controls direction of current
# (1, 0) would be a current moving to the right
# (0, 1) would be a current moving down
# (1, 1) would be a current moving down and to the right
# The length of the vector determines the speed.
@export var current_direction := Vector2(1, 0)
@export var current_strength: float = 300.0

# Array for storing all the bodies in the collision area
var bodies_in_area: Array[Node2D] = []

func _physics_process(delta: float) -> void:
	# Loop through every body that is currently inside area
	for body in bodies_in_area:
		# Check if the body has a 'velocity' property, so only physics bodies like Player are affected
		if "velocity" in body:
			# Apply constant force to the body's velocity
			body.velocity += current_direction.normalized() * current_strength * delta

func _on_body_entered(body: Node2D) -> void:
	# Add physics body to array automatically when it enters collision body
	if body not in bodies_in_area:
		bodies_in_area.append(body)

func _on_body_exited(body: Node2D) -> void:
	# Remove physics body automatically when it exits collision body
	if body in bodies_in_area:
		bodies_in_area.erase(body)
