extends Node

var designated_brain_cell : BrainCell
var stat_interpreter_stat_type = null 

# components
@onready var parent_container : CharacterBody3D = $"../.."
@onready var defect_increase_delay_timer : Timer = $DefectIncreaseDelayTimer
@onready var jolt_particles : GPUParticles3D =  $"../../JoltParticles"
@onready var jolt_sound_loop : AudioStreamPlayer3D = $JoltSoundLoop

### SHAKE AND SCALE SETTINGS ####
var base_positon : Vector3
var base_scale : Vector3

var jolt_movement_tween : Tween

var scale_enabled : bool = false 
@export var scale_amount : Vector3 = Vector3(0.15, 0.15, 0.15)
@export var scale_speed : float = 0.12

# shake settings
var shake_enabled : bool = false 
@export var shake_amount : Vector3 = Vector3(0.08, 0.08, 0.08)
@export var shake_speed : float = 0.03
#################################

func _ready() -> void:
	defect_increase_delay_timer.connect('timeout', _handle_defect_increase_delay_timer_timeout)


func state_start() : 
	# get des. brain cell from parent
	designated_brain_cell = parent_container.designated_brain_cell 
	# turn on shake and scale
	shake_enabled = true
	scale_enabled = true
	# set base positoo and scale
	base_positon = parent_container.global_position
	base_scale = parent_container.scale 
	# start defect increase timer
	defect_increase_delay_timer.start()
	# start particles
	jolt_particles.emitting = true
	
	jolt_sound_loop.play()
	
	create_jolt_tween()
	
func create_jolt_tween() :	
	
	jolt_movement_tween = create_tween()	
	jolt_movement_tween.set_loops()
	
	
	# scale up
	if scale_enabled:
		jolt_movement_tween.parallel().tween_property(
			parent_container,
			"scale",
			base_scale + scale_amount,
			scale_speed
		)
	
	# shake offset
	if shake_enabled:
		jolt_movement_tween.parallel().tween_property(
			parent_container,
			"position",
			base_positon + Vector3(
				randf_range(-shake_amount.x, shake_amount.x),
				randf_range(-shake_amount.y, shake_amount.y),
				randf_range(-shake_amount.z, shake_amount.z)
			),
			shake_speed
		)
	
	# scale back down
	if scale_enabled:
		jolt_movement_tween.tween_property(
			parent_container,
			"scale",
			base_scale,
			scale_speed
		)
	
	# move back
	if shake_enabled:
		jolt_movement_tween.parallel().tween_property(
			parent_container,
			"position",
			base_positon,
			shake_speed
		)
	
	
func _handle_defect_increase_delay_timer_timeout() :
	
	# update designated cell refrence
	designated_brain_cell = parent_container.designated_brain_cell 
	
	# if this is from hidden station we define the specific type. else the manager picks
	if stat_interpreter_stat_type != null : 
		GLCellManagerBus.emit_signal('interpreter_jolt_increase_cell_defect', designated_brain_cell, stat_interpreter_stat_type)
	else :
		GLCellManagerBus.emit_signal('cell_container_jolt_increase_cell_defect', designated_brain_cell)

func state_end() : 
	# get rid of obj refrence
	designated_brain_cell = null
	# kill tween
	if jolt_movement_tween :
		jolt_movement_tween.kill()
	# reset scale and position
	parent_container.scale = base_scale
	parent_container.position = base_positon 
	# stop timer
	defect_increase_delay_timer.stop()	
	# end particles
	jolt_particles.emitting = false
	
	jolt_sound_loop.stop()

	
