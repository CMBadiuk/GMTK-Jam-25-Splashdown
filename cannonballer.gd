extends Node2D

@export var warning_indicator_scene: PackedScene
@export var splash_damage_scene: PackedScene

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	# $AttackTimer.timeout.connect(_on_attack_timer_timeout)
	attack()

func attack():
	if not is_instance_valid(player):
		queue_free() # If no player, just disappear.
		return

	# 1. Spawn the warning indicator.
	var target_position = player.global_position
	var warning = warning_indicator_scene.instantiate()
	print("Spawning Warning")
	get_tree().root.add_child.call_deferred(warning)
	warning.global_position = target_position

	# 2. Pause this script and wait for the warning's lifetime to finish.
	# We get the timer from the warning scene itself.
	await warning.get_node("LifetimeTimer").timeout

	# 3. Once the warning's timer is done, spawn the splash.
	var splash = splash_damage_scene.instantiate()
	print("Spawning Splash")
	get_tree().root.add_child(splash)
	splash.global_position = target_position

	# 4. Now that the full sequence is complete, destroy the Cannonballer.
	queue_free()
