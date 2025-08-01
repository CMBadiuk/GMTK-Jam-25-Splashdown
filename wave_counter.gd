extends Area2D

var counter := 0

func _on_body_entered(body: Node2D) -> void:
	# when player passes wave counter, increment counter by 1, and increase strength of current
	if body.is_in_group("player"):
		counter+=1
		print("Counter: ", counter)
		get_node("/root/World/RiverCurrents").on_player_pass_wave_counter()
