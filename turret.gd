extends Node2D

@export var health: int = 5
@export var enemy_projectile_scene: PackedScene

var player_target: Node2D = null
var can_shoot := true

@onready var head = $Head
@onready var fire_rate_timer = $FireRateTimer

func _ready():
	# Connect signals from the detection area and timer
	$FiringRange.body_entered.connect(_on_detection_range_body_entered)
	$FiringRange.body_exited.connect(_on_detection_range_body_exited)
	fire_rate_timer.timeout.connect(_on_fire_rate_timer_timeout)

func _process(delta: float):
	# If we have a target, aim at it.
	if is_instance_valid(player_target):
		head.look_at(player_target.global_position)

		if can_shoot:
			shoot()

func shoot():
	if not enemy_projectile_scene:
		return

	can_shoot = false
	fire_rate_timer.start()

	var projectile = enemy_projectile_scene.instantiate()
	get_tree().root.add_child(projectile)

	# Spawn the projectile at the muzzle's position and rotation
	projectile.global_transform = head.get_node("Muzzle").global_transform

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()

func _on_detection_range_body_entered(body: Node2D):
	# A body entered our range, set it as the target.
	player_target = body

func _on_detection_range_body_exited(body: Node2D):
	# If the body that left is our target, clear the target.
	if body == player_target:
		player_target = null
		
func _on_damage_collider_area_entered(area: Area2D):
	# This is called when a player projectile hits our hitbox.
	# We call our own take_damage function.
	take_damage(1)
	# We also need to destroy the projectile that hit us.
	area.queue_free()

func _on_fire_rate_timer_timeout():
	can_shoot = true
