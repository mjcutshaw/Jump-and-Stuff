extends PlayerInfo

@export var crouchSpeedMin: int = 20
@export var frictionCrouch: float = 0.1 * Util.tileSize
@export var minLongJumpVelocity: int = 30
@export var transformTime: float = 0.2

#TODO: make anim to move colision shape
#LOOKAT: crouch stores consec jumps

func enter() -> void:
	pass


func exit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRig, "scale", Vector2(player.scale.x, 1), transformTime).from_current()


func physics(delta) -> void:
	player.move_and_slide()
	apply_friction(frictionCrouch)


func visual(delta) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRig, "scale", Vector2(player.scale.x, 0.5), transformTime).from_current()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when sliding
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("crouch"):
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if Input.is_action_just_pressed("jump"):
		if abs(player.velocity.x) > minLongJumpVelocity:
			return State.JumpLong
		else:
			return State.JumpCrouch

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.emit_signal("helperUsed", Util.helper.bufferJump)
		return State.Jump
#	if player.is_on_slope: #TODO: slope detection into slide
#		return State.Slide

	return State.Null
