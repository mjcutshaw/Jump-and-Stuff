extends Node

## sets timers to one shot ##
func _ready() -> void:
	for timers in get_children():
		timers.one_shot = true
