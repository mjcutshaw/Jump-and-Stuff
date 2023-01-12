extends PlayerInfo

#TODO: if coming from double create special jump
#TODO: bounce of enemy changes to another long jump
#TODO: spin combo, ref https://www.mariowiki.com/Double_kick

@export var jumpModifier: float = 0.9
@export var velocityModifier: float = 1.35


func enter() -> void:
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpTriple.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.velocity.x = moveSpeed * velocityModifier * player.facing


func exit() -> void:
	player.sounds.jump.pitch_scale = 1


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(0, player.velocity.y * delta)):
		player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	gravity_logic(gravityJump, delta)
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO add control lockout or deminished air turn
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("dive"):
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		return State.JumpApex
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall

	return State.Null
