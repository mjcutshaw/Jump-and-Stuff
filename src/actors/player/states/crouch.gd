extends PlayerState

@export var crouchSpeedMin: int = 20
@export var transformTime: float = 0.2

#TODO: make anim to move colision shape
func enter() -> void:
	pass


func exit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRig, "scale", Vector2(player.scale.x, 1), transformTime).from_current()


func physics(delta) -> void:
	pass


func visual(delta) -> void:
	print(player.facing)
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRig, "scale", Vector2(player.scale.x, 0.5), transformTime).from_current()
	#FIXME: breaks facing logic


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("crouch"):
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall

	return State.Null
