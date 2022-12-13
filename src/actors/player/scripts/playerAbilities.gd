extends Resource
class_name PlayerAbilities

#TODO: all abilities should get an upgrade and shards/modifires/charms
#TODO: add unlockable skills enum


var unlockedJumpAir: bool = false
var unlockedJumpWall: bool = false
var unlockedDashGround: bool = false
var unlockedDashAir: bool = false
var unlockedDashUp: bool = false
var unlockedDashDown: bool = false
var unlockedDashWall: bool = false
var unlockedDashJump: bool = false
var unlockedDashClimb: bool = false
var unlockedGlide: bool = false
var unlockedHookShot: bool = false
var unlockedSwim: bool = false
var unlockedSwimDash: bool = false
var unlockedBurrow: bool = false


var maxJump: int = 1
var maxJumpAir: int = 1
var maxDash: int = 1

enum list {
	Null,
	All,
	JumpAir,
	JumpWall,
	DashAll,
	DashSide,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	Glide,
	HookShot,
	Climb,
	Grab,
	Swim,
	SwimDash,
	Burrow,
	}
	
enum abilityTargetType {Null, hookShot, grappleHook, burrow}
