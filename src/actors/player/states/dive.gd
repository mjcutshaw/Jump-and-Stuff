extends PlayerInfo
#FIXME: rotation is borked

@export var transformTime: float = 0.2
var landed: bool = false

func enter() -> void:
	player.characterRig.rotate(90 * player.facing)
	player.velocity.x = moveSpeed
#	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#	tween.tween_property(player.characterRig, "rotation", 120 * player.facing, transformTime).from_current()


func exit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "rotation", 0 , transformTime).from_current()
	landed = false


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
#	air_velocity_logic(moveSpeed, accelerationAir, frictionAir) #TODO neutral movement
	fall_speed_logic(terminalVelocity)
	if player.is_on_floor():
		player.velocity.y = 0
		apply_friction(frictionGround)


func visual(delta) -> void:
	squash_and_stretch(delta)
	
	if player.is_on_floor() and !landed:
		player.characterRig.rotate(-45 * player.facing)
#		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#		tween.tween_property(player.characterRig, "rotation", 67 , transformTime).from_current()
		landed = true


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor() and player.velocity.x == 0:
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
