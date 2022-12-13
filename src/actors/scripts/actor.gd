extends CharacterBody2D
class_name Actor

@export var healthMax: int = 4

var health: int :
	set(v):
		health = clamp(v, 0, healthMax)
		EventBus.emit_signal("playerHea")
