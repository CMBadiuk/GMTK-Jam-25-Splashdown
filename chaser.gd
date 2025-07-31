extends CharacterBody2D

@export var speed: float = 250.0
@export var health: int = 3

var player: Node2D

func _ready() -> void:
	# Find player as soon as they're spawned
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		# If player isn't present for any reason, do nothing
		return
	# 1. Get player's current position
	var player_position = player.global_position
	
	# 2. Find optimal path to player using the Nav Server
	var path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, global_position, player_position, true	)
