extends Actor
class_name  Player

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sm: Node = $StateMachine

var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.ZERO
var moveStrength: Vector2 = Vector2.ZERO
var transformTime: float = 0.3


func _ready() -> void:
	sm.init()


func _unhandled_input(event: InputEvent) -> void:
	sm.handle_input(event)


func _physics_process(delta: float) -> void:
	sm.physics(delta)
	sm.state_check(delta)

	align_with_floor()
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

func align_with_floor() -> void:
	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
	else:
		if rotation != 0:
			var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "rotation", 0, transformTime).from_current()
