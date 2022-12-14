extends Actor
class_name  Player
#FIXME: can use capsule on test project and not this one
var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sm: Node = $StateMachine

var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.ZERO
var moveStrength: Vector2 = Vector2.ZERO


func _ready() -> void:
	sm.init()


func _unhandled_input(event: InputEvent) -> void:
	sm.handle_input(event)


func _physics_process(delta: float) -> void:
	sm.physics(delta)
	sm.state_check(delta)

	get_move_input()
	
	EventBus.emit_signal("debugVelocity", velocity.round())


func _process(delta: float) -> void:
	sm.visual(delta)
	sm.sound(delta)


func get_move_input() -> void:
	var deadzoneRadius: float = 0.2
	#TODO: make deadzone radius in settings
	var inputStrength: = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	moveStrength =  inputStrength if inputStrength.length() > deadzoneRadius else Vector2.ZERO
	
	moveDirection =  moveStrength.normalized()
	
	if moveDirection != Vector2.ZERO:
		lastMoveDirection = moveDirection




