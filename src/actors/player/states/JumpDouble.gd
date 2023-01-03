extends PlayerInfo

@export var jumpModifier: float = 1.25

func enter() -> void:
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpDouble.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.timers.coyoteJump.stop()
	player.timers.consecutiveJump.stop()
	player.jumpedDouble = true
	player.jumped = false


func exit() -> void:
	player.sounds.jump.pitch_scale = 1
	


func physics(delta) -> void:
	gravity_logic(gravityJump, delta)
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		#LOOKAT: minjump height?
		consecutive_jump_cancel()
		return State.Fall

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y >= 0:
		return State.Fall

	return State.Null
