extends Node

# This function takes a path to a scene file and loads it.
func goto_scene(scene_path: String):
	# get_tree().change_scene_to_file() is the standard way to switch scenes.
	# It will unload the current scene and load the new one.
	get_tree().change_scene_to_file(scene_path)
