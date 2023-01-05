extends Node


@onready var coyoteJump: Timer = $CoyoteJump
@onready var consecutiveJump: Timer = $ConsecutiveJump
@onready var bufferJump: Timer = $BufferJump


func _ready() -> void:
	## sets timers to one shot ##
#	for timers in get_children():
#		timers.one_shot = true
	
	consecutiveJump.timeout.connect(consecutive_jump_timeout)

func consecutive_jump_timeout() -> void:
	EventBus.emit_signal("playerConsecutiveJump")
