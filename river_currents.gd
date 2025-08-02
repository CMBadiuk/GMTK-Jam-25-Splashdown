extends Node

# array storing the six river currents
@export var river_currents: Array[Node]
var current_strength := 300.0

func on_player_pass_wave_counter():
	# increment current strength by 50 every time player passes wave counter
	current_strength += 50.0
	for river_current in river_currents:
		river_current.set_strength(current_strength)
