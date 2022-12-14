extends MarginContainer

@onready var stateLabel: Label = $MarginContainer/VBoxContainer/State
@onready var velocityLabel: Label = $MarginContainer/VBoxContainer/Velocity
@onready var debugLabel: Label = $MarginContainer/VBoxContainer/Debug

func _ready():
	EventBus.connect("debugState", set_state_label)
	EventBus.connect("debugVelocity", set_velocity_label)
	EventBus.connect("debug", set_debug_label)

func set_state_label(info) -> void:
	stateLabel.text = "State: " + str(info)

func set_velocity_label(info) -> void:
	velocityLabel.text = "Velocity: " + str(info)

func set_debug_label(info) -> void:
	debugLabel.text = str(info)
