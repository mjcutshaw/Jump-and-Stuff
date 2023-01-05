extends PlayerInfo
#TODO: make player flip
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
	tween.tween_property(player.characterRig,"rotation", -player.facing * 2 * PI, 0.5)


func exit() -> void:
	player.sounds.jump.pitch_scale = 1
	player.characterRig.rotation = 0 * PI


func physics(delta) -> void:
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
		#LOOKAT: minjump height?
		consecutive_jump_cancel()
		return State.Fall

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y >= 0:
		return State.Fall

	return State.Null
