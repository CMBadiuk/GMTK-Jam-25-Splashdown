extends Node

# Define signals that will be emitted when stats change.
signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal ammo_changed(new_ammo)
signal max_ammo_changed(new_max_ammo)
signal player_died

var max_health: int = 5
var health: int = max_health:
	set(value):
		health = clamp(value, 0, max_health)
		health_changed.emit(health)
		if health == 0:
			player_died.emit()

var max_ammo: int = 50
var ammo: int = max_ammo:
	set(value):
		ammo = clamp(value, 0, max_ammo)
		ammo_changed.emit(ammo)

func _ready():
	# Emit initial values when the game starts.
	health_changed.emit(health)
	max_health_changed.emit(max_health)
	ammo_changed.emit(ammo)
	max_ammo_changed.emit(max_ammo)

func reset():
	# A function to reset stats for a new game.
	self.health = max_health
	self.ammo = max_ammo
