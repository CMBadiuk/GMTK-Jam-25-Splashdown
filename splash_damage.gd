extends Area2D

@export var knockback_force: float = 800.0
var can_splash:= true

# sound
@onready var splash: AudioStreamPlayer2D = $Splash
@onready var splash_2: AudioStreamPlayer2D = $Splash2
var splash_fx = []

func _ready() -> void:
	$DurationTimer.timeout.connect(queue_free)
	splash_fx = [splash, splash_2]
	
# randomly select a sound to play
func play_random_sound(players: Array) -> void:
	if players.size() == 0:
		print("No AudioStreamPlayer nodes provided")
		return
		
	var random_index = randi() % players.size()
	players[random_index].play()
	
func _physics_process(delta: float) -> void:
	if can_splash:
			apply_shockwave()
			play_random_sound(splash_fx)
			can_splash = false
	
func apply_shockwave():
	# Get all nodes in the "player" and "enemies" groups.
	var bodies_to_check = get_tree().get_nodes_in_group("player")
	bodies_to_check.append_array(get_tree().get_nodes_in_group("enemies"))

	var splash_radius = $CollisionShape2D.shape.radius

	for body in bodies_to_check:
		# Make sure the node is actually a physics body before proceeding.
		if not body is PhysicsBody2D:
			continue

		var distance = global_position.distance_to(body.global_position)

		# Only affect bodies that are within our radius.
		if distance < splash_radius:
			var direction = global_position.direction_to(body.global_position)
			
			# Use the same falloff logic as before.
			var falloff = 1.0 - (distance / splash_radius)
			falloff = max(0, falloff)

			body.velocity += direction * knockback_force * falloff

			if body.is_in_group("player"):
				body.take_damage(2)
