extends PlayerInfo


@export var upHillFrictionModifier: float = 2.0
@export var flatGroundFrictionModifier: float = 1.75
@export var downHillAccel: float = 50
@export var transformTime: float = 0.05


func enter() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "rotation", 45 * player.facing, transformTime).from(0)


func exit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "rotation", 0 , transformTime).from_current()


func physics(delta) -> void:
	player.move_and_slide()
	player.velocity.y = 1000 #TODO: find better way to snap character
	if rad_to_deg(player.groundAngle) < -1:
		if sign(player.velocity.x) == -1:
			player.velocity.x -= downHillAccel ## Speed up on down hill
		else:
			apply_friction(frictionGround * upHillFrictionModifier) ## Slow on up hill
	if rad_to_deg(player.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += downHillAccel #TODO: make like friction func, need a top speed or make this function
		else:
			apply_friction(frictionGround * upHillFrictionModifier)
	else:
		apply_friction(frictionGround * 1.5)
	
	player.rotation = player.get_floor_normal().angle() + PI/2


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		#TODO: special jump, timer to get a boosted jump
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if  player.velocity.x == 0:
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
