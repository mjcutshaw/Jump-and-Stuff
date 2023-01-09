extends PlayerInfo
#FIXME: rotation is borked
#TODO: timer to dive right before ground to rool
#TODO: falling to long and bonk

@export var transformTime: float = 0.05
var landed: bool = false

func enter() -> void:
	player.velocity.x = moveSpeed
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "rotation", 90 * player.facing, transformTime).from(0)


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
#		player.characterRig.rotate(-45 * player.facing)
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRig, "rotation", 45 * player.facing, transformTime).from(0)
		landed = true


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		#TODO: special jump 
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor() and player.velocity.x == 0:
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
