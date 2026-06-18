extends Node3D

# components
@export var energy_decrease_symbol_scene : PackedScene
@onready var spawn_delay_timer : Timer = $SpawnDelay
@onready var spawn_spots : Node3D = $SpawnSpots

var interpreter_len : int


func _ready() -> void:
	spawn_delay_timer.connect("timeout", _create_symbol)
	spawn_delay_timer.one_shot = true


func _start_spawning_decrease_particles(interpreters_to_jolt : Array) -> void:
	interpreter_len = len(interpreters_to_jolt)
	_start_random_spawn_timer()


func _stop_spawning_decrease_particles() -> void:
	interpreter_len = 0
	spawn_delay_timer.stop()


func _start_random_spawn_timer() -> void:
	spawn_delay_timer.wait_time = randf_range(4.0, 7.0)
	spawn_delay_timer.start()


func _create_symbol() -> void:
	if interpreter_len <= 0:
		return
	
	var symbol_instance = energy_decrease_symbol_scene.instantiate()
	var spawn_position : Node3D = spawn_spots.get_children().pick_random()
	
	spawn_position.add_child(symbol_instance)
	
	# decide correct amount of energy to jolt
	if interpreter_len > 1:
		symbol_instance._load(IVDefectEventManager.interpreter_jolt_energy_decrease_multiple)
	else: 
		symbol_instance._load(IVDefectEventManager.interpreter_jolt_energy_decrease_single)
	
	_start_random_spawn_timer()
