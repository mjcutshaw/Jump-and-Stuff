extends PlayerState

#TODO: hold down to pass through semisolids

func enter() -> void:
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, 0.4).from_current()


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
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
