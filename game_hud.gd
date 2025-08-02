extends Control

@onready var health_bar = $HealthLabel/TexHealthBar
@onready var ammo_bar = $AmmoLabel/TexAmmoBar
@onready var wave_label = $WaveLabel

func _ready():
	# Connect to the global signals from PlayerStats
	PlayerStats.health_changed.connect(_on_health_changed)
	PlayerStats.max_health_changed.connect(_on_max_health_changed)
	PlayerStats.ammo_changed.connect(_on_ammo_changed)
	PlayerStats.max_ammo_changed.connect(_on_max_ammo_changed)
	
	var wave_counter_area = get_tree().get_first_node_in_group("wave_counter")
	if wave_counter_area:
		var wave_counter_script_node = wave_counter_area.get_child(0)
		if wave_counter_script_node:
			wave_counter_script_node.wave_changed.connect(_on_wave_changed)
	else:
		print("ERROR: Could not find the wave_counter node!")
	
	health_bar.value = 10
	health_bar.max_value = 10
	
	ammo_bar.value = 50
	ammo_bar.value = 50
	
	wave_label.text = ""

func _on_health_changed(new_health):
	health_bar.value = new_health

func _on_max_health_changed(new_max_health):
	health_bar.max_value = new_max_health

func _on_ammo_changed(new_ammo):
	ammo_bar.value = new_ammo
	
func _on_max_ammo_changed(new_max_ammo):
	ammo_bar.max_value = new_max_ammo
	
func _on_wave_changed(new_wave):
	wave_label.text = "Wave " + str(new_wave)
	print("Should be printing new wave")
