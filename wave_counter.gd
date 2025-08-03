extends Area2D

signal wave_changed(new_wave)

# sounds
#@onready var spawn_sound_1: AudioStreamPlayer2D = $Sounds/SpawnSound1
#@onready var spawn_sound_2: AudioStreamPlayer2D = $Sounds/SpawnSound2
#@onready var spawn_sound_3: AudioStreamPlayer2D = $Sounds/SpawnSound3
#var spawn_fx = []

var counter := -1

#func _ready():
	#spawn_fx = [spawn_sound_1, spawn_sound_2, spawn_sound_3]
	
func play_random_sound(players: Array) -> void:
	if players.size() == 0:
		print("No AudioStreamPlayer nodes provided")
		return
		
	var random_index = randi() % players.size()
	players[random_index].play()
	
# Called when player enters wave counter
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		counter += 1
		print("Wave Counter: ", counter)
		wave_changed.emit(counter)

		# notify river current system (if applicable)
		get_node("/root/World/RiverCurrents").on_player_pass_wave_counter()

		# Update all enemy spawn points with this new wave number
		for spawn_point in get_tree().get_nodes_in_group("spawn_point"):
			spawn_point.set_budget_for_wave(counter)

# Returns the current wave number
func get_current_wave() -> int:
	return counter
