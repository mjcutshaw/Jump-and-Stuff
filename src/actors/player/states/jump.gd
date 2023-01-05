extends PlayerInfo

#todo: add edge push
#TODO: bring in proper stats and functions

func enter() -> void:
	player.particles.jump.restart()
	player.sounds.jump.play()
	player.velocity.y = jumpVelocity
	player.timers.coyoteJump.stop()
	player.jumped = true


func exit() -> void:
	pass


func physics(delta) -> void:
	#LOOKAT: move to func
	if player.test_move(player.global_transform, Vector2(0, player.velocity.y * delta)):
		player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
	gravity_logic(gravityJump, delta)
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		#LOOKAT: minjump height?
		consecutive_jump_cancel() #lookat: maybe change to percent of jump
		return State.Fall

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex

	return State.Null
