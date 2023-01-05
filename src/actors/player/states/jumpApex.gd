extends PlayerInfo


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics(delta) -> void:
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
