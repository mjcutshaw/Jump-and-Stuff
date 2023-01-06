extends PlayerInfo

#TODO: better reaction to going to a slope that is too steep
#TODO: get friction from enviroment
#TODO: ledge stop
@export var skidPercent: float = 0.8
var skidding: bool = false

func enter() -> void:
	player.animPlayer.play("walk")
	player.particles.walk.emitting = true
	skidding = false


func exit() -> void:
	player.particles.walk.emitting = false
	player.sounds.walk.stop()


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > moveSpeed * skidPercent  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.moveDirection.x != 0 and player.velocity.x < moveSpeed:
		apply_acceleration(accelerationGround)
	elif player.moveDirection.x == 0:
		apply_friction(frictionGround)
	elif player.velocity.x >= moveSpeed:
		momentum_logic(moveSpeed, true)
	
	if player.moveDirection.x == 0 and (player.ledgeLeft or player.ledgeRight): ## stops on ledge w/o input
		player.velocity.x = move_toward(player.velocity.x, 0, frictionGround)
		EventBus.emit_signal("helperUsed", Util.helper.stopOnLedge)

	player.rotation = player.get_floor_normal().angle() + PI/2 #FIXME: turn off if on ledge, need to use raycast to check ground


func visual(delta) -> void:
	squash_and_stretch(delta)
	speed_bend(false)


func sound(delta: float) -> void:
	if !player.sounds.walk.playing:
		player.sounds.walk.pitch_scale = randf_range(0.8, 1.2)
		player.sounds.walk.play()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()

	return State.Null


func state_check(delta: float) -> int:
	if skidding:
		return State.Skid
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall
#	if abs(player.velocity.x) > stats.moveSpeed:
#		return State.Turbo
	if player.velocity.x == 0:
		return State.Idle
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.emit_signal("helperUsed", Util.helper.bufferJump)
		return consecutive_jump_logic()

	return State.Null

