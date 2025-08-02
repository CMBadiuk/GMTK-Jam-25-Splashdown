extends Node2D

var wave = 0
@export var enemy_budget: int = 0

# Define enemies with a cost and weight
# Higher weight = more frequent
# Higher cost = more expensive to spawn
var enemies = [
	{"scene": preload("res://chaser.tscn"), "cost": 1, "weight": 3},  # common enemy
	{"scene": preload("res://turret.tscn"), "cost": 3, "weight": 1},   # rare enemy
	{"scene": preload("res://cannonballer.tscn"), "cost": 2, "weight": 1}
]

# Weighted random enemy selection
func choose_enemy_weighted() -> Dictionary:
	var options: Array[int] = [] # create empy array to store enemies to choose from
	for enemy_index in range(enemies.size()):
		for _i in range(enemies[enemy_index]["weight"]): # multiply each enemy by their weight
			options.append(enemy_index)
	var selected_index = options[randi() % options.size()] # random number from 0 -> int(options.size)
	return enemies[selected_index] # higher weight enemies more frequent

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
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position  # Spawns at this spawn point

	enemy_budget -= enemy["cost"] # deduct cost of enemy from spawn point budget after spawned

	# wait randomly before next spawn
	if enemy_budget >= get_min_enemy_cost():
		await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
		spawn_next_enemy()

# called when this node enters the scene tree
func _ready() -> void:
	randomize()

# called externally to update per wave
func set_budget_for_wave(new_wave: int) -> void:
	wave = new_wave
	enemy_budget = wave * 2
	spawn_next_enemy()
	print("Enemy Budget: ", enemy_budget)

# helper to find the cheapest enemy
func get_min_enemy_cost() -> int:
	var min_cost := int(INF)
	for enemy in enemies:
		min_cost = min(min_cost, enemy["cost"])
	return min_cost
