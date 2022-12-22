extends StaticBody2D

##kinda like smartshape

@onready var body: Polygon2D = $Polygon2D
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var outline: Line2D = $Line2D
@onready var path: Path2D = $Path2D

func _ready() -> void:
	var shape = path.curve.get_baked_points()
	
	body.polygon = shape
	collision.polygon = shape
	outline.points = shape
