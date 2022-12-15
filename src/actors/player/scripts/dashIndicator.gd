extends Node2D
@tool

@export var color: Color = Color.WHITE

func _draw() -> void:
	draw_circle(position, 6, color)
