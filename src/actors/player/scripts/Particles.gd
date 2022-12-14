extends Node2D
#TODO: get ground color for particles
#TODO: landed particles need to be based on velocity

@onready var walk: GPUParticles2D = $ParticlesWalking
@onready var skid: GPUParticles2D = $ParticlesSkid
@onready var land: GPUParticles2D = $ParticlesLand
@onready var jump: GPUParticles2D = $ParticlesJump
@onready var jumpDouble: GPUParticles2D = $ParticlesJumpDouble
@onready var jumpTriple: GPUParticles2D = $ParticlesJumpTriple
@onready var dashSide: GPUParticles2D = $ParticlesDashSide
@onready var dashUp: GPUParticles2D = $ParticlesDashUp
@onready var dashDown: GPUParticles2D = $ParticlesDashDown

@onready var player = get_parent().get_parent()

func _ready() -> void:
	dashSide.process_material.color = AbilityColor.dashSideColor
	dashUp.process_material.color = AbilityColor.dashUpColor
	dashDown.process_material.color = AbilityColor.dashDownColor

func _process(delta: float) -> void:
	walk.process_material.color = player.groundColor
	skid.process_material.color = player.groundColor
	land.process_material.color = player.groundColor
	jump.process_material.color = player.groundColor
	jumpDouble.process_material.color = player.groundColor
	jumpTriple.process_material.color = player.groundColor
