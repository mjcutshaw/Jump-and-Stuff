extends PlayerState


func enter() -> void:
	player.velocity.y = -600
	
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, 0.4).from_current()


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	player.velocity.y += 20


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y >= 0:
		return State.Fall

	return State.Null
