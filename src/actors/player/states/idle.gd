extends PlayerState

var transformTime: float = 0.1

func enter() -> void:
	## Pulls player off the wall
	#TODO: check rotation to move off wall
	player.velocity = Vector2(0, 10)
	player.set_up_direction(Vector2.UP)
	if player.characterRig.skew != 0:
		var tween = create_tween() #LOOKAT: move to player info
		tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()

#	player.rotation = player.get_floor_normal().angle() + PI/2 #FIXME: bring back

func visual(delta) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection.x != 0:
		return State.Walk
	if !player.is_on_floor():
		return State.Fall

	return State.Null
