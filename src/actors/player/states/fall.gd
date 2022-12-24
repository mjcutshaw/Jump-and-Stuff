extends PlayerState

#TODO: hold down to pass through semisolids
var gravity = 4000
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
	player.velocity.y += gravity * delta
#	player.set_up_direction(-player.global_transform.y)
#	player.velocity = player.velocity.rotated(0)
	player.move_and_slide()
	



func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.emit_signal("helperUsed", Util.helper.coyoteJump)
			return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.sounds.land.play()
		player.particles.land.restart()
		player.rotation = player.get_floor_normal().angle() + PI/2 #TODO: better ground detection
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
