extends PlayerInfo
#TODO: falling to long and bonk

@export var transTime: float = 0.1
func enter() -> void:
	player.set_up_direction(Vector2.UP)
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, transTime).from_current()
	player.velocity = player.velocity.rotated(0)


func exit() -> void:
	pass


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
	fall_speed_logic(terminalVelocity)
	
	if player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding():
		var leftAngle: float = player.detectorGroundLeft.get_collision_normal().angle() + PI/2
		var rightAngle: float = player.detectorGroundRight.get_collision_normal().angle() + PI/2
		
		if !player.detectorGroundRight.is_colliding():
			player.groundAngle = leftAngle
		if !player.detectorGroundLeft.is_colliding():
			player.groundAngle = rightAngle
		else:
			player.groundAngle = (leftAngle + rightAngle)/2
		
		player.set_up_direction(-player.transform.y)
		player.velocity = player.velocity.rotated(player.rotation)
		player.move_and_slide()
		player.velocity = player.velocity.rotated(-player.rotation)
		player.rotation = player.groundAngle
#		print(leftAngle)
#		print(player.groundAngle)


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.emit_signal("helperUsed", Util.helper.coyoteJump)
			return consecutive_jump_logic()
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("dive"):
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.sounds.land.play()
		player.particles.land.restart()
		player.rotation = player.get_floor_normal().angle() + PI/2 #TODO: better ground detection
		player.timers.consecutiveJump.start()
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
