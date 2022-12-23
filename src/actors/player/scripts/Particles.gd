extends Node2D

@onready var dashSide: GPUParticles2D = $ParticlesDashSide
@onready var dashUp: GPUParticles2D = $ParticlesDashUp
@onready var dashDown: GPUParticles2D = $ParticlesDashDown
@onready var walking: GPUParticles2D = $ParticlesWalking
@onready var land: GPUParticles2D = $ParticlesLand
@onready var jump: GPUParticles2D = $ParticlesJump

func _ready() -> void:
	dashSide.process_material.color = AbilityColor.dashSideColor
	dashUp.process_material.color = AbilityColor.dashUpColor
	dashDown.process_material.color = AbilityColor.dashDownColor
