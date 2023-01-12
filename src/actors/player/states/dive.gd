extends PlayerInfo
#FIXME: rotation is borked
#TODO: falling to long and bonk
#TODO: Roll state, timer to dive right before ground to roll

@export var diveSpeedMultiplier: float = 1
@export var transformTime: float = 0.05


func enter() -> void:
	player.velocity.x = max(moveSpeed * diveSpeedMultiplier, abs(player.velocity.x)) * player.facing  ## dive at dive speed or current velocity, whichever's high
	player.velocity.y = 10
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "rotation", 90 * player.facing, transformTime).from(0)


func exit() -> void:
	pass


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
	fall_speed_logic(terminalVelocity)
	align_to_ground()


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRig, "rotation", 45 * player.facing, transformTime).from(0)
		return State.BellySlide

	return State.Null
