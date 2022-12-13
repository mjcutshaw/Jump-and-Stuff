extends PlayerState


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics(delta) -> void:
	if !player.is_on_floor():
		player.move_and_slide()
		player.velocity.y = 2000
	else:
		player.velocity = Vector2.ZERO


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection != Vector2.ZERO:
		return State.Walk

	return State.Null
