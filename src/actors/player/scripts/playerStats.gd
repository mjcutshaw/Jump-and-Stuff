extends Resource
class_name PlayerStats

@export var healthMax: int = 4
var health: int = 3

@export var baseSpeed: int = 15
var turboSpeed #min speed for wall run  #TODO: make based off base speed
@export var accelerationGround: float = .3
@export var frictionGround: float = .5

@export var baseJumpHeight: float = 4.5
@export var jumpTimeToPeak: float = 0.5
@export var jumpTimeToDescent: float = 0.25

