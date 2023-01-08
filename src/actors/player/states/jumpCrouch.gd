extends PlayerInfo


@export var jumpModifier: float = 1.4


func enter() -> void:
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpTriple.restart()
	player.velocity.y = jumpVelocity * jumpModifier


func exit() -> void:
	player.sounds.jump.pitch_scale = 1


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
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		return State.Apex
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		return State.Walk

	return State.Null
