extends Resource
class_name PlayerStats

var healthMax: int = 4
var health: int = 3

@export var baseSpeed: int = 15
var moveSpeed: int = baseSpeed * Util.tileSize
var accelerationGround: float = .3 * Util.tileSize
var frictionGround: float = .5 * Util.tileSize
