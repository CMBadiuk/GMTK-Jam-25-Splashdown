extends Node2D

@onready var character_sprite = $CharacterSprite
@onready var lifetime_timer = $LifetimeTimer

func _ready():
	# Connect timer's timeout to a function that destroys the node
	lifetime_timer.timeout.connect(queue_free)
	var tween = create_tween()
	
	character_sprite.scale = Vector2(1, 1)
	
	tween.tween_property(character_sprite, "scale", Vector2(0.1, 0.1), lifetime_timer.wait_time)
