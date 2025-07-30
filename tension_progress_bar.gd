extends TextureProgressBar

func _ready():
	# Find player and connect to its signal
	var player = get_tree().get_first_node_in_group("player")
	player.tension_changed.connect(self.on_tension_changed)
	
func on_tension_changed(new_tension):
	self.value = new_tension
