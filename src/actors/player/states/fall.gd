extends PlayerInfo

#TODO: hold down to pass through semisolids

#FIXME: breaks going from walk to fall

func enter() -> void:
	player.neutral_move_direction_logic()
	player.set_up_direction(Vector2.UP)
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, 0.4).from_current()
		player.velocity = player.velocity.rotated(0)


func exit() -> void:
	pass


func physics(delta) -> void:
	gravity_logic(gravityFall, delta)
	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
	player.move_and_slide()


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
		#TODO: buffer jump

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.sounds.land.play()
		player.particles.land.restart()
		player.rotation = player.get_floor_normal().angle() + PI/2 #TODO: better ground detection
		player.timers.consecutiveJump.start()
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
