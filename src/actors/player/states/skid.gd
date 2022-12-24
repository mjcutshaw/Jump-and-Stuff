extends PlayerInfo

#TODO: jump flip state

@export var skidDuration: float = 0.5 #TODO: make speed relavent to skid
@export var frictionSkid: float = 1.0
@export var transformTime: float = 0.2
var skidTime: float


func enter() -> void:
	player.sounds.skid.play()
	player.particles.skid.restart()
	skidTime = skidDuration
	var tween = create_tween() #TODO: make based on speed as well
	tween.tween_property(player.characterRig, "skew", 0.3, transformTime).from_current()


func exit() -> void:
	player.sounds.skid.stop()
	var tween = create_tween()
	tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func physics(delta) -> void:
	skidTime -= delta
	if player.moveDirection.x == 0 :
		apply_friction(frictionSkid)


func visual(delta) -> void:
	speed_bend(false, moveSpeed, 0.3)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if skidTime < 0:
		if player.velocity.x == 0 or player.moveDirection.x == 0:
			return State.Idle
		else:
			player.velocity.x == 0 #FIXME: getting stuck in skid loop sometimes
			return State.Walk
	

	return State.Null
