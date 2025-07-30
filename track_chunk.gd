extends Path2D
# Straight Track
@onready var line_2d = $Line2D

func _ready():
	# Copy the points from the Path2D to the Line2D to make it visible
	line_2d.points = self.curve.get_baked_points()
