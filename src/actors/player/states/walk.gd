extends PlayerState

var gravity = 100

func enter() -> void:
	player.animPlayer.play("walk")


func exit() -> void:
	pass


func physics(delta) -> void:
	if player.moveDirection.x != 0:
		if abs(player.velocity.x) < 1200:
			player.velocity.x = move_toward(abs(player.velocity.x), 1200, stats.accelerationGround) * player.moveDirection.x
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, stats.frictionGround)
#
#	if player.is_on_wall():
#		player.velocity.x = 0
	#TODO: move to PSpeed state with
	player.velocity.y += gravity * delta
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)
	
	player.rotation = player.get_floor_normal().angle() + PI/2


func visual(delta) -> void:
	player.head.skew = remap(-player.velocity.x, 0, abs(stats.moveSpeed), 0.0, 0.1)
	player.body.rotate(player.get_rot())


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		return State.Fall

	if player.velocity.x == 0:
		return State.Idle

	return State.Null

