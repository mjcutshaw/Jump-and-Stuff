extends PlayerState

#TODO: hold down to pass through semisolids

func enter() -> void:
	pass


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	player.velocity.y += 100


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		return State.Idle

	return State.Null
