extends Node

# Array to hold track chunk scenes
@export var track_chunks: Array[PackedScene]

# Reference to the player's coaster scene
@export var coaster_scene: PackedScene

# Reference to currently active chunks
var active_chunks = []
# Position where next chunk should be placed
var spawn_position = Vector2.ZERO

func _ready():
	# Spawn first two chunks
	spawn_chunk()
	spawn_chunk()
	
	#Spawn player and add it to first chunk's path
	var coaster = coaster_scene.instantiate()
	var first_chunk = active_chunks[0]
	first_chunk.add_child(coaster)
	
func _process(delta):
	# Basic logic to spawn a new chunk when the player gets close to the end
	# A more robust system would use signals or Area2Ds
	if active_chunks.size() > 0:
		var coaster = get_tree().get_nodes_in_group("player")[0] # Assumes player is in a group
		var last_chunk = active_chunks[-1]
		
		# If the player is on the last chunk, spawn another one
		if coaster.get_parent() == last_chunk:
			spawn_chunk()
			# Clean up old chunks that are far behind
			if active_chunks.size() > 3:
				var chunk_to_remove = active_chunks.pop_front()
				chunk_to_remove.queue_free()
				
func spawn_chunk():
	#Pick random chunk from list
	var random_chunk_scene = track_chunks.pick_random()
	var new_chunk = random_chunk_scene.instantiate()
	
	# Position at the end of previous chunk
	new_chunk.position = spawn_position
	add_child(new_chunk)
	active_chunks.append(new_chunk)
	
	#Update next spawn position, from last point of curve transformed to global coords and stored
	var curve = new_chunk.curve
	var last_point_local_pos = curve.get_point_position(curve.get_point_count() - 1)
	spawn_position = new_chunk.to_global(last_point_local_pos)
