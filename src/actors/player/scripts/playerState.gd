extends Node
class_name PlayerState



enum State {
	Null,
	Spawn,
	Teleport,
	Die,
	Idle,
	Walk,
	Turbo,
	Skid,
	Crouch,
	Jump,
	JumpAir,
	JumpWall,
	JumpReverse,
	Apex,
	Fall,
	DashSide,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	Glide,
	WallSlide,
	WallGrab,
	HookShot,
	Swim,
	SwimDash,
	
	FallDamage,
	Bonk,
}


var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> int:
	return State.Null

func visual(delta: float) -> void:
	pass

func sound(delta: float) -> void:
	pass

func physics(delta: float) -> void:
	pass

func state_check(delta: float) -> int:
	return State.Null
