extends Actor
class_name  Player
#FIXME: can use capsule on test project and not this one
#TODO: joystick vs dpad/keyboard input
var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sm: Node = $StateMachine
@onready var characterRig: Node2D = $CharacterRig
@onready var eyes: Node2D = $CharacterRig/Eyes
@onready var body: Node2D = $CharacterRig/Body
@onready var particles: Node2D = $CharacterRig/Particles
@onready var timers: Node = $Timers
@onready var sounds: Node = $Sounds
@onready var detectorGroundLeft: RayCast2D = $Raycasts/Ground/Left
@onready var detectorGroundRight: RayCast2D = $Raycasts/Ground/Right

var eyeDirection: int = 1 #TODO: randomizer on spawn
var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.ZERO
var moveStrength: Vector2 = Vector2.ZERO
var aimDirection: Vector2 = Vector2.ZERO
var lastAimDirection: Vector2 = Vector2.ZERO
var aimStrength: Vector2 = Vector2.ZERO
var groundAngle: float
var velocityRotated: Vector2 = Vector2.ZERO

var neutralMoveDirection: bool = false

var facing: int

var jumped: bool
var jumpedDouble: bool

var ledgeLeft: bool
var ledgeRight: bool

func _ready() -> void:
	sm.init()


func _unhandled_input(event: InputEvent) -> void:
	sm.handle_input(event)


func _physics_process(delta: float) -> void:
	sm.physics(delta)
	sm.state_check(delta)

	get_move_input()
	facing_logic()
	if is_on_floor(): #TODo: create is grounded using floor raycasts
		ledge_detection()
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

#LOOKAT: maybe move these to playerinfo
func facing_logic():
	#FIXME: breaks with crouch state
	#TODO: need to be able to send variables
	if moveDirection.x == 1 and eyeDirection == -1:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(eyes, "position", Vector2(0, eyes.position.y), 0.2).from_current()
		eyeDirection = 1
		particles.scale.x = 1
		facing = -eyeDirection
	if moveDirection.x == -1  and eyeDirection == 1:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(eyes, "position", Vector2(-8, eyes.position.y), 0.2).from_current()
		eyeDirection = -1
		particles.scale.x = -1
		facing = -eyeDirection


func ledge_detection() -> void:
	if is_on_floor() and !detectorGroundLeft.is_colliding():
		ledgeLeft = true
	else:
		ledgeLeft = false
	
	if is_on_floor() and !detectorGroundRight.is_colliding():
		ledgeRight = true
	else:
		ledgeRight = false
