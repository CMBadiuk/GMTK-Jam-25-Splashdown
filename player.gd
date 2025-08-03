extends CharacterBody2D

# Enum to define control schemes
enum ControlScheme { MOUSE_KB, CONTROLLER }

# Strength of the player's push, editable in the Inspector
@export var move_force: float = 500.0
# This adds drag to the player
@export var friction: float = 0.95
# Reference to water droplet scene
@export var water_droplet_scene: PackedScene
# @export var health: int = 5

@onready var refill_timer = $RefillTimer
@onready var swim_timer = $SwimSoundTimer

# sounds:
@onready var audio_player = $AudioStreamPlayer
#water guns:
@onready var water_gun_1: AudioStreamPlayer2D = $SoundEffects/WaterGuns/WaterGun1
@onready var water_gun_2: AudioStreamPlayer2D = $SoundEffects/WaterGuns/WaterGun2
var water_gun_fx = []
@onready var swim_1: AudioStreamPlayer2D = $SoundEffects/Swim/Swim1
@onready var swim_2: AudioStreamPlayer2D = $SoundEffects/Swim/Swim2
@onready var swim_3: AudioStreamPlayer2D = $SoundEffects/Swim/Swim3

var swim_fx = []


var can_shoot:= true
var active_scheme: ControlScheme = ControlScheme.MOUSE_KB
var last_controller_aim := Vector2.RIGHT # Default aim for controller

func _ready():
	$DamageFlashTimer.timeout.connect(_on_damage_flash_timer_timeout)
	refill_timer.timeout.connect(_on_refill_timer_timeout)
	water_gun_fx = [water_gun_1, water_gun_2]
	swim_fx = [swim_1, swim_2, swim_3]
	
# randomly select a sound to play
func play_random_sound(players: Array) -> void:
	if players.size() == 0:
		print("No AudioStreamPlayer nodes provided")
		return
		
	var random_index = randi() % players.size()
	players[random_index].play()

func _unhandled_input(event: InputEvent) -> void:
	# Runs whenever there's an input event, used to detect last used input device
	if event is InputEventMouseMotion:
		active_scheme = ControlScheme.MOUSE_KB
	elif  event is InputEventJoypadMotion or event is InputEventJoypadButton:
		active_scheme = ControlScheme.CONTROLLER
		print("Controller input detected")

func _process(delta: float) -> void:
	# Handle aiming and check for shooting input here
	aim()
	if Input.is_action_pressed("Fire") and can_shoot and not Input.is_action_pressed("Refill"):
		shoot()
		
	if Input.is_action_pressed("Refill") and refill_timer.is_stopped() and not Input.is_action_pressed("Fire"):
		refill_timer.start()
	elif Input.is_action_just_released("Refill") or Input.is_action_pressed("Fire"):
		refill_timer.stop()
	# print(PlayerStats.ammo)

func _physics_process(delta: float) -> void:
	# Get movement input direction
	var input_direction := Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")

	# If player is providing input, apply a force
	if input_direction != Vector2.ZERO:
		velocity += input_direction * move_force * delta
	# Apply friction to velocity
	velocity *= friction

	# Play swim sound every time timer times out
	if !swim_timer.is_stopped():
		pass  # already running
	else:
		play_random_sound(swim_fx)
		swim_timer.start()
		
	# Move player based on physics inputs acting on it
	move_and_slide()

func aim() -> void:
	# This function routes to appropriate aim logic for control scheme
	match active_scheme:
		ControlScheme.MOUSE_KB:
			aim_with_mouse()
		ControlScheme.CONTROLLER:
			aim_with_controller() # Currently not switching schemes properly. Figure this out later if at all

func aim_with_mouse() -> void:
	# Look at the global mouse position.
	look_at(get_global_mouse_position())

func aim_with_controller() -> void:
	# Get input from the controller's right stick.
	var aim_direction := Input.get_vector("Contr_Aim_Left", "Contr_Aim_Right", "Contr_Aim_Up", "Contr_Aim_Down")

	# We only update the rotation if the stick is actively being pushed.
	# This prevents the player from snapping back to a default rotation.
	if aim_direction != Vector2.ZERO:
		rotation = aim_direction.angle()
		last_controller_aim = aim_direction # Store the last direction
	# If the stick is neutral, the player continues facing the last known direction

func shoot() -> void:
	# This function handles firing a projectile.
	# First, check if the scene has been assigned in the editor.
	if PlayerStats.ammo <= 0 or not can_shoot:
		print("Ammo empty")
		return
	
	if not water_droplet_scene:
		print("Water droplet scene not set on player!")
		return
		
	refill_timer.stop()
		
	# Set can_shoot to false, start cooldown timer
	can_shoot = false
	$FireRateTimer.start()
	PlayerStats.ammo -= 1

	play_random_sound(water_gun_fx)
	
	# Create a new instance of our water droplet, parent it to world root
	var droplet = water_droplet_scene.instantiate()
	get_tree().root.add_child(droplet)

	# Position the new droplet at the Muzzle's global position and rotation
	var muzzle = $Muzzle
	droplet.global_transform = muzzle.global_transform
	
	# If using a controller and the aim stick is neutral, we need to ensure the projectile still fires in the correct direction
	if active_scheme == ControlScheme.CONTROLLER:
		droplet.rotation = last_controller_aim.angle()
		
func take_damage(amount: int):
	PlayerStats.health -= amount
	print("Player took ", amount, " damage! Health is now ", PlayerStats.health)
	$Sprite2D.modulate = Color.RED
	$DamageFlashTimer.start()
	
	if PlayerStats.health <= 0:
		print("GAME OVER")
		PlayerStats.player_died.emit()
		queue_free()
		
func _on_refill_timer_timeout():
	if PlayerStats.ammo < PlayerStats.max_ammo:
		PlayerStats.ammo += 1
		
func _on_damage_flash_timer_timeout():
	$Sprite2D.modulate = Color.WHITE


func _on_fire_rate_timer_timeout() -> void:
	# Calls when FireRateTimer finishes
	can_shoot = true
