extends PathFollow2D

# Add signal for UI to listen to
signal tension_changed(new_tension)

const MOVE_SPEED = 300.0 # In pixels per second
const TENSION_PER_SECOND = 15.0
const BALANCE_RECOVERY = 25.0

var tension = 0.0
var last_velocity = Vector2.ZERO

func _process(delta):
	self.progress += MOVE_SPEED * delta
	
	var rotation_speed = abs(self.rotation - self.get_parent().rotation)
	
	if Input.is_action_pressed("Balance"):
		tension -+ BALANCE_RECOVERY * delta
	else:
		if rotation_speed > 0.05: # NOT FINAL VALUE
			tension += TENSION_PER_SECOND * 2 * delta
		else:
			tension += TENSION_PER_SECOND * delta
			
	tension = clamp(tension, 0.0, 100.0)
	tension_changed.emit(tension)
	
	if tension >= 100.0:
		get_tree().reload_current_scene() # Game over!
