extends Area2D

# Speed of projectile in pixels per second
@export var speed: float = 800.0

func _physics_process(delta: float) -> void:
	# Move projectile forward based on its own rotation, with its "right" direction acting as forward
	position += transform.x * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	# Fired when physics body is hit. Can have damage logic later
	if body.is_in_group("enemy"):
		body.take_damage(1)
	queue_free() # Destroys the droplet instance
	
func _on_timer_timeout() -> void:
	# Fires when the Timer node finishes
	queue_free()
