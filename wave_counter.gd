extends Area2D

var counter := 0

# Called when player enters wave counter
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		counter += 1
		print("Wave Counter: ", counter)

		# notify river current system (if applicable)
		get_node("/root/World/RiverCurrents").on_player_pass_wave_counter()

		# Update all enemy spawn points with this new wave number
		for spawn_point in get_tree().get_nodes_in_group("spawn_point"):
			spawn_point.set_budget_for_wave(counter)

# Returns the current wave number
func get_current_wave() -> int:
	return counter
