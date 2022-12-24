extends PlayerState
class_name PlayerInfo

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

@onready var moveSpeed: int = stats.baseSpeed * Util.tileSize
