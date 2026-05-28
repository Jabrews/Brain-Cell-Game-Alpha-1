extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var mesh_instance : MeshInstance3D = $"../../MeshInstance3D"
@onready var dying_particles : GPUParticles3D = $"../../DyingParticles"
@onready var death_sound : AudioStreamPlayer3D = $"../../PixelExsplode"
@onready var worm_moving_sound : AudioStreamPlayer3D = $"../../WormMovingSound"


func _ready() -> void: 
	pass

func state_start() :
	
	# hacky fix to stopping sound continie
	worm_moving_sound.max_db = -24.0
	
	await get_tree().create_timer(0.2).timeout
	parent_slug.velocity = Vector3.ZERO
	
	
	await get_tree().create_timer(1).timeout
	
	dying_particles.emitting = true
	
	mesh_instance.visible = false
	death_sound.play()
	
	await dying_particles.finished
	
	
	parent_slug.queue_free()


func state_process(_delta) : 
	pass


func state_end() : 
	pass
