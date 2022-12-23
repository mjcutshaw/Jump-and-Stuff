extends PlayerState

var gravity = 100
#TODO: get friction from enviroment
#TODO: momentum logic, ledge stop, coyote timers

func enter() -> void:
	player.animPlayer.play("walk")
	player.particlesWalking.emitting = true


func exit() -> void:
	player.particlesWalking.emitting = false


func physics(delta) -> void:
	if player.moveDirection.x != 0:
		if abs(player.velocity.x) < stats.moveSpeed:
			player.velocity.x = move_toward(abs(player.velocity.x), stats.moveSpeed, stats.accelerationGround) * player.moveDirection.x
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, stats.frictionGround)
	#TODO: skid, jump reverse
#	if player.is_on_wall():
#		player.velocity.x = 0
	#TODO: move to PSpeed state with
	player.velocity.y += gravity * delta
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)
	
	player.rotation = player.get_floor_normal().angle() + PI/2 #FIXME: turn off if on ledge


func visual(delta) -> void:
	player.characterRig.skew = remap(player.velocity.x, 0, abs(stats.moveSpeed), 0.0, 0.1)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.coyoteJumpTimer.start()
		return State.Fall

	if player.velocity.x == 0:
		return State.Idle

	return State.Null

