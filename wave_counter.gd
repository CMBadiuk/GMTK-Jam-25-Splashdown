extends Area2D

var counter := 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		counter+=1
		print("Counter: ", counter)
		
