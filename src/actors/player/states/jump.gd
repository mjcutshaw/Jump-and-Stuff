extends PlayerState

var gravity = 4000
var JMP = 2000
#TODO: bring in proper stats and functions

func enter() -> void:
	player.particlesJump.restart()
	player.sounds.jump.play()
	player.velocity.y = -2000
	player.timerCoyoteJump.stop()


func exit() -> void:
	pass


func physics(delta) -> void:
	player.velocity.y += gravity * delta
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)


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
