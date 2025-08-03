extends CharacterBody2D

@export var speed: float = 450.0
@export var health: int = 3
@export var bounce_force: float = 400.0
@export var friction: float = 0.95

var player: Node2D
var can_attack:= true

# sounds:
@onready var duck_1: AudioStreamPlayer2D = $Sounds/Duck1
@onready var duck_2: AudioStreamPlayer2D = $Sounds/Duck2
@onready var duck_3: AudioStreamPlayer2D = $Sounds/Duck3
var duck_fx = []
@onready var quack_timer: Timer = $QuackTimer



func _ready() -> void:
	# Find player as soon as they're spawned
	player = get_tree().get_first_node_in_group("player")
	$AttackCooldownTimer.timeout.connect(_on_attack_cooldown_timer_timeout)
	duck_fx = [duck_1, duck_2, duck_3]
	quack_timer.timeout.connect(_on_quack_timer_timeout)
	start_quack_timer()

func _on_quack_timer_timeout():
	play_random_sound(duck_fx)
	start_quack_timer()  # restart for the next quack

func start_quack_timer():
	# Random interval between quacks (adjust range to taste)
	var delay = randf_range(2.0, 6.0)
	quack_timer.start(delay)
	
func play_random_sound(players: Array) -> void:
	if players.size() == 0:
		print("No AudioStreamPlayer nodes provided")
		return
		
	var random_index = randi() % players.size()
	players[random_index].play()
	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		# If player isn't present for any reason, do nothing
		print("Player not found")
		return
	# 1. Get player's current position
	var player_position = player.global_position
	# print("Player position: ", player.global_position)
	# 2. Find optimal path to player using the Nav Server
	var path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, global_position, player_position, true)
	# 3. Move towards the next point on that path
	if path.size() > 1:
		var move_direction = global_position.direction_to(path[1])
		velocity += move_direction * speed * delta
	else:
		velocity = Vector2.ZERO
	velocity *= friction
		
	move_and_slide()
	look_at(player.global_position)
	
	# Check for collision with the player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			print("Chaser caught the player!")
			collider.take_damage(1)
			play_random_sound(duck_fx)
			# Bounce back
			velocity += collision.get_normal() * bounce_force
			print("Velocity = ", velocity)
			# Start attack cooldown
			can_attack = false
			$AttackCooldownTimer.start()
			
func take_damage(amount: int):
	health -= amount
	print("Chaser took ", amount, " damage. Health is now ", health)
	if health <= 0:
		play_random_sound(duck_fx)
		await get_tree().create_timer(0.2).timeout
		queue_free()

func _on_attack_cooldown_timer_timeout():
	can_attack = true
