extends PlayerState


func enter() -> void:
	pass
	player.velocity= Vector2.ZERO #FIXME: needs to deccel


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()

#	player.rotation = player.get_floor_normal().angle() + PI/2

func visual(delta) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection.x != 0:
		return State.Walk

	return State.Null
