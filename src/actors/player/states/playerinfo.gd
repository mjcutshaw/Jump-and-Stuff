extends PlayerState
class_name PlayerInfo

#TODO: update stats when upgraded found

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

var moveSpeed: int
var jumpVelocity: float
var gravityJump: float
var gravityFall: float

var accelerationGround: float
var frictionGround: float

func _ready() -> void:
	update_stats()
	EventBus.connect("playerStatsUpdate", update_stats)
	EventBus.connect("playerConsecutiveJump", consecutive_jump_cancel)

func update_stats() -> void:
	var jumpHeight: float
	
	moveSpeed = stats.baseSpeed * Util.tileSize
	
	accelerationGround = stats.accelerationGround * Util.tileSize
	frictionGround = stats.frictionGround * Util.tileSize
	
	jumpHeight = stats.baseJumpHeight * Util.tileSize
	gravityJump = 2 * jumpHeight / pow(stats.jumpTimeToPeak, 2)
	gravityFall = 2 * jumpHeight / pow(stats.jumpTimeToDescent, 2)
	jumpVelocity = -sqrt(2 * gravityJump * jumpHeight)

	#FIXME: called for every state


func gravity_logic(amount, delta) -> void:
	player.velocity.y += amount * delta


func apply_acceleration(amount) -> void:
	#FIXME: need to multiply times delta/ (1/FRAMERATE)
	#TODO: variable target speed
	player.velocity.x = move_toward(abs(player.velocity.x), moveSpeed, amount) * player.moveStrength.x

func apply_friction(amount) -> void:
	#FIXME: need to multiply times delta/ (1/FRAMERATE)
	player.velocity.x = move_toward(player.velocity.x, 0, amount)

func speed_bend(forwardLean: bool = true, topSpeed = moveSpeed, leanAmount: float = 0.1) -> void:
	if forwardLean:
		player.characterRig.skew = remap(player.velocity.x, 0, topSpeed, 0.0, leanAmount)
	if !forwardLean:
		player.characterRig.skew = remap(-player.velocity.x, 0, topSpeed, 0.0, leanAmount)

#TODO: squash and strech, landing squish

func squash_and_stretch(delta):
#	#TODO: not squishing the on the x
	if !player.is_on_floor():
		player.characterRig.scale.y = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 0.75, 1.25)
		player.characterRig.scale.x = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 1.25, 0.75)

	player.characterRig.scale.x = lerp(player.characterRig.scale.x, 1.0, 1.0 - pow(0.01, delta))
	player.characterRig.scale.y = lerp(player.characterRig.scale.y, 1.0, 1.0 - pow(0.01, delta))

func consecutive_jump_logic() -> int:
	if player.jumped:
		return State.JumpDouble
	elif player.jumpedDouble:
		return State.JumpTriple
	else:
		return State.Jump

func consecutive_jump_cancel() -> void:
	#LOOKAT: only canceled from falls and canceled jumps. watch other states for extra jumps
	#TODO: make landed function to call
	player.jumped = false
	player.jumpedDouble = false
