extends Line2D


func _ready() -> void:
	points = get_parent().get_polygon ()
	#FIXME: need to add first point to be the last point
