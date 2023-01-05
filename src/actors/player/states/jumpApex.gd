extends PlayerInfo


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(0, player.velocity.y * delta)):
		player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
	gravity_logic(gravityApex, delta)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y > jumpApexHeight:
		return State.Fall

	return State.Null
