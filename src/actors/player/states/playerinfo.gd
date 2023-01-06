extends PlayerState
class_name PlayerInfo

#TODO: update stats when upgraded found

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

var moveSpeed: int
var jumpVelocity: float
var gravityJump: float
var gravityFall: float
var gravityApex: float

var accelerationGround: float
var frictionGround: float
var accelerationAir: float = .5 * Util.tileSize
var frictionAir: float = .7 * Util.tileSize

var jumpApexHeight: float = 40
var jumpCornerCorrectionVertical: int = 10
var jumpCornerCorrectionHorizontal: int = 15

func _ready() -> void:
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
	gravityApex = 2 * jumpHeight / pow(stats.jumpTimeAtApex, 2)
	jumpVelocity = -sqrt(2 * gravityJump * jumpHeight)

	#FIXME: called for every state


func gravity_logic(amount: float, delta) -> void:
	player.velocity.y += amount * delta


func apply_acceleration(amount: float) -> void:
	#FIXME: need to multiply times delta/ (1/FRAMERATE)
	#TODO: variable target speed
	player.velocity.x = move_toward(abs(player.velocity.x), moveSpeed, amount) * player.moveStrength.x


func apply_friction(amount: float) -> void:
	#FIXME: need to multiply times delta/ (1/FRAMERATE)
	player.velocity.x = move_toward(player.velocity.x, 0, amount)


func momentum_logic(speed: float, useMoveDirection: bool) -> void:
	#TODO: need to get accel and deccel, lerp function
	if useMoveDirection:
		player.velocity.x = player.moveDirection.x * max(abs(speed), abs(player.velocity.x))
	if !useMoveDirection:
		if player.velocity.x == 0:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x =  max(abs(speed), abs(player.velocity.x)) * player.facing


func air_velocity_logic(speed: float, acceleration: float, friction: float) -> void:
	var airTurn: bool
	if player.velocity.x != 0  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		airTurn = true
	#FIXME: air turn should stop other direction and timer till move other way
	if airTurn:
		player.velocity.x = move_toward(player.velocity.x, speed * player.moveDirection.x, acceleration) 
	elif !airTurn:
		if player.moveDirection.x != 0 and abs(player.velocity.x) < speed:
			apply_acceleration(acceleration)
		elif player.moveDirection.x == 0:
			apply_friction(friction)
		elif abs(player.velocity.x) >= speed:
			#TODO: look at not needing moveDirection
			momentum_logic(speed, true)


func speed_bend(forwardLean: bool = true, topSpeed = moveSpeed, leanAmount: float = 0.1) -> void:
	if forwardLean:
		player.characterRig.skew = remap(player.velocity.x, 0, topSpeed, 0.0, leanAmount)
	if !forwardLean:
		player.characterRig.skew = remap(-player.velocity.x, 0, topSpeed, 0.0, leanAmount)


func squash_and_stretch(delta):
#	#TODO: not squishing the on the x
	if !player.is_on_floor():
		player.characterRig.scale.y = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 0.75, 1.25)
		player.characterRig.scale.x = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 1.25, 0.75)

	player.characterRig.scale.x = lerp(player.characterRig.scale.x, 1.0, 1.0 - pow(0.01, delta))
	player.characterRig.scale.y = lerp(player.characterRig.scale.y, 1.0, 1.0 - pow(0.01, delta))


func consecutive_jump_logic() -> int:
	#TODO: velocity needs to be greater than zero to increase
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
