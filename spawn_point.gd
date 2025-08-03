extends Node2D

var wave = 0
@export var enemy_budget: int = 0
enum SpawnTypes { LAND, WATER }
@export var spawn_type: SpawnTypes

# range variables for spawn point locations
@export var move_radius_x: float = 500.0 # max x-range
@export var move_radius_y: float = 500.0 # max y-range
@export var allowed_area: Area2D # assign in inspector
var original_position: Vector2 # original position

# Define enemies with a cost and weight
# Higher weight = more frequent
# Higher cost = more expensive to spawn
var enemies_water = [
	{"scene": preload("res://chaser.tscn"), "cost": 1, "weight": 3},  # common enemy
	{"scene": preload("res://cannonballer.tscn"), "cost": 3, "weight": 1} # rare enemy
]

var enemies_land = [
	{"scene": preload("res://turret.tscn"), "cost": 2, "weight": 1},   # rare enemy
]

# Weighted random enemy selection
func choose_enemy_weighted() -> Dictionary:
	var chosen_enemy
	
	if spawn_type == SpawnTypes.WATER:
		var options: Array[int] = [] # create empy array to store enemies to choose from
		for enemy_index in range(enemies_water.size()):
			for _i in range(enemies_water[enemy_index]["weight"]): # multiply each enemy by their weight
				options.append(enemy_index)
		var selected_index = options[randi() % options.size()] # random number from 0 -> int(options.size)
		chosen_enemy = enemies_water[selected_index] # higher weight enemies more frequent
		
	elif spawn_type == SpawnTypes.LAND:
		var options: Array[int] = [] # create empy array to store enemies to choose from
		for enemy_index in range(enemies_land.size()):
			for _i in range(enemies_land[enemy_index]["weight"]): # multiply each enemy by their weight
				options.append(enemy_index)
		var selected_index = options[randi() % options.size()] # random number from 0 -> int(options.size)
		chosen_enemy = enemies_land[selected_index] # higher weight enemies more frequent
		
	return chosen_enemy

# Attempt to spawn an enemy within budget
func spawn_next_enemy() -> void:
	if enemy_budget < get_min_enemy_cost():
		return  # Insufficient budget

	var enemy: Dictionary = choose_enemy_weighted() # get random enemy from enemies
	var attempts := 0
	while enemy["cost"] > enemy_budget and attempts < 10: # initial enemy chosen too expensive
		enemy = choose_enemy_weighted() # select a different enemy
		attempts += 1

	if enemy["cost"] > enemy_budget:
		return  # still too expensive

	var instance = enemy["scene"].instantiate()
	get_tree().current_scene.call_deferred("add_child", instance)
	instance.global_position = global_position  # Spawns at this spawn point

	enemy_budget -= enemy["cost"] # deduct cost of enemy from spawn point budget after spawned

	# wait randomly before next spawn
	if enemy_budget >= get_min_enemy_cost():
		await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
		spawn_next_enemy()

# called when this node enters the scene tree
func _ready() -> void:
	randomize()
	original_position = global_position
	
func is_point_inside_area(point: Vector2) -> bool:
	# checks if spawn point is in it's allowed area based off its type
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = point
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.collision_mask = allowed_area.collision_layer  # use the allowed area's layer

	var results = space_state.intersect_point(params, 10)

	for item in results:
		if item.collider == allowed_area:
			return true
	return false
	

# called externally to update per wave
func set_budget_for_wave(new_wave: int) -> void:
	wave = new_wave
	enemy_budget = wave * 3
	
	var valid = false
	var attempt = 0
	
	while not valid and attempt < 20:
		attempt += 1
		var offset_x = randf_range(-move_radius_x, move_radius_x)
		var offset_y = randf_range(-move_radius_y, move_radius_y)
		var candidate_pos = original_position + Vector2(offset_x, offset_y)
		
		global_position = candidate_pos # temporarily move
		
		# wait for physics to update areas
		if is_point_inside_area(candidate_pos):
			global_position = candidate_pos
			valid = true
			
	if not valid:
		global_position = original_position # return to original position

	spawn_next_enemy()
	print("Enemy Budget: ", enemy_budget)

# helper to find the cheapest enemy
func get_min_enemy_cost() -> int:
	var min_cost := int(INF)
	if spawn_type == SpawnTypes.LAND:
		for enemy in enemies_land:
			min_cost = min(min_cost, enemy["cost"])
	elif spawn_type == SpawnTypes.WATER:
		for enemy in enemies_water:
			min_cost = min(min_cost, enemy["cost"])
	return min_cost
#
