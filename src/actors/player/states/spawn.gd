extends PlayerState

@export var transformTime: float = 0.4


func enter() -> void:
	var tween = create_tween()
	tween.tween_property(player.characterRig, "scale", Vector2(1,1), transformTime).from(Vector2(0,0))


func exit() -> void:
	player.characterRig.scale = Vector2(1,1) ## Makes sure character is full size ##
	#TODO: find better way


func physics(delta) -> void:
	if !player.is_on_floor():
		player.move_and_slide()
		player.velocity.y = 2000
	else:
		player.velocity = Vector2.ZERO


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection != Vector2.ZERO:
		return State.Walk

	return State.Null
