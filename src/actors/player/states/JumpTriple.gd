extends PlayerInfo


@export var jumpModifier: float = 1.5


func enter() -> void:
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpTriple.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.timers.coyoteJump.stop()
	player.timers.consecutiveJump.stop()
	player.jumpedDouble = false
	var tween = create_tween()
	tween.tween_property(player.characterRig,"rotation", -player.facing * 2 * PI, 0.5) ## flip, #TODO: find way to rotate around center


func exit() -> void:
	player.sounds.jump.pitch_scale = 1
	player.characterRig.rotation = 0 * PI


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(0, player.velocity.y * delta)):
		player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	gravity_logic(gravityJump, delta)
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
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
		player.velocity.y = max( player.velocity.y, (jumpVelocity * jumpModifier) * percentMinJumpVelocity)
		return State.Fall
	if Input.is_action_just_pressed("dive"):
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		if player.velocity.x != 0:
			return State.Walk
		else:
			#TODO: special pose
			return State.Idle
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall

	return State.Null
