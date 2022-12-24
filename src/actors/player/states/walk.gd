extends PlayerInfo

#TODO: better reaction to going to a slope that is too steep
#TODO: get friction from enviroment
#TODO: momentum logic, ledge stop, coyote timers


func enter() -> void:
	player.animPlayer.play("walk")
	player.particlesWalking.emitting = true


func exit() -> void:
	player.particlesWalking.emitting = false
	player.sounds.walk.stop()


func physics(delta) -> void:
	player.move_and_slide()
	if player.moveDirection.x != 0:
		if abs(player.velocity.x) < moveSpeed:
			player.velocity.x = move_toward(abs(player.velocity.x), moveSpeed, stats.accelerationGround) * player.moveDirection.x
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, stats.frictionGround)

	player.rotation = player.get_floor_normal().angle() + PI/2 #FIXME: turn off if on ledge


func visual(delta) -> void:
	player.characterRig.skew = remap(player.velocity.x, 0, abs(moveSpeed), 0.0, 0.1)


func sound(delta: float) -> void:
	if !player.sounds.walk.playing:
		player.sounds.walk.pitch_scale = randf_range(0.8, 1.2)
		player.sounds.walk.play()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.timerCoyoteJump.start()
		return State.Fall
	if abs(player.velocity.x) > stats.moveSpeed:
		return State.Turbo
	if player.velocity.x == 0:
		return State.Idle

	return State.Null

