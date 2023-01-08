@tool
extends StaticBody2D


@export var color: Color = Color.BLACK:
	get: return color
	set(v):
		color = v
		queue_redraw()

func  _ready() -> void:
	for bodies in get_children():
		bodies.color = color
