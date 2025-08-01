extends Node2D

func _ready():
	# Connect timer's timeout to a function that destroys the node
	$LifetimeMeter.timeout.connect(queue_free)
