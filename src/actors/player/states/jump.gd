extends PlayerState

var gravity = 4000
var JMP = 2000


func enter() -> void:
#	player.velocity.x -= JMP * sin(player.groundDetectorL.get_collision_normal().angle_to(Vector2(0, -1)))
#	player.velocity.y -= JMP * cos(player.groundDetectorL.get_collision_normal().angle_to(Vector2(0, -1)))
	player.velocity.y = -2000
#	player.velocity = Vector2(player.velocity.x+sin(player.rotation)*JMP,player.velocity.y-cos(player.rotation)*JMP)
	
#	if player.rotation != 0:
#		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#		tween.tween_property(player, "rotation", 0, 0.4).from_current()


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
