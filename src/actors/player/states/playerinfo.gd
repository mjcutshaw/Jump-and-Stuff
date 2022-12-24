extends PlayerState
class_name PlayerInfo

#TODO: update stats when upgraded found

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

var moveSpeed: int

@onready var accelerationGround: float = .3 * Util.tileSize
@onready var frictionGround: float = .5 * Util.tileSize

func _ready() -> void:
	update_stats()
	EventBus.connect("playerStatsUpdate", update_stats)

func update_stats() -> void:
	moveSpeed = stats.baseSpeed * Util.tileSize


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
