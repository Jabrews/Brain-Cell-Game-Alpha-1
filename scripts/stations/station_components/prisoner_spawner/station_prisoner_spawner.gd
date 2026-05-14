extends Node


# componnets
@export var prisoners_parent_node : Node 
@onready var pris_spawn_limit_screen : Node2D = $PrisonerCreateLimitTv/TvFrontPannel/SubViewport/PrisonerSpawnerLimit
@onready var prisoner_spots : Array[Node3D] = [
	$PrisonerSpawnSpots/Spot1,
	$PrisonerSpawnSpots/Spot2,
	$PrisonerSpawnSpots/Spot3,
	$PrisonerSpawnSpots/Spot4,
]
@onready var prisoner_instance : PackedScene = preload("res://scenes/characters/prisoner/Prisoner.tscn")

var finale_round_loop_active : bool 


func _ready() -> void:
	GLCellCreatorBus.connect('get_newest_prisoner_cells', _handle_get_newest_prisoner_cells)
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	
	# finale round tells btn it cant be pressed
	GLGameManagerBus.connect('finale_turn', _handle_finale_turn)
	GLGameManagerBus.connect('finale_turn_ended_new_round_proceed', _handle_next_round)
	
	
# btn down
func handle_pris_spawn_btn_pressed() : 	
	
	if finale_round_loop_active :	
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# reset curr picked for new selection
	IVPrisonerSpawner.curr_picked_pris_per_turn = 0
	
	# get rid of all prior prisoner instances 
	# hacky ! will have unentended logic for target compare. loop
	GLCellManagerBus.emit_signal('delete_remaining_prisoners')
	
	# initate next round logic. this will create prisoners 
	# wont do anything if target compare.
	GLGameManagerBus.emit_signal('attempt_next_turn')

# get new prisoners into spot
func _handle_get_newest_prisoner_cells(new_prisoner_cells : Array[BrainCell]) : 
	
	# this means 'attempt next turn was success'
	# therfore btn succes
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')

	
	# reset all seats 
	for spot in prisoner_spots:
		spot.is_being_sat_in = false
	
	# update screen
	pris_spawn_limit_screen.update_pris_spawner_limit_screen()
	
	# spawn prisoner in open spot
	for prisoner_cell in new_prisoner_cells:
		for spot in prisoner_spots:
			if not spot.is_being_sat_in:
				create_prisoner_instance(prisoner_cell, spot.global_position)
				spot.is_being_sat_in = true   
				break   

# create prisoner instance
func create_prisoner_instance(prisoner_cell : BrainCell, spot_glob_pos : Vector3) : 
	var prisoner : CharacterBody3D = prisoner_instance.instantiate()
	prisoner.name = prisoner_cell.name
	prisoners_parent_node.add_child(prisoner)			
	prisoner.global_position = spot_glob_pos
	prisoner.designated_brain_cell = prisoner_cell
			
				
# player get limited choice per each batch
func _handle_prisoner_picked_by_player(_prisoner_cell : BrainCell) :
	var next_picked_pris = IVPrisonerSpawner.curr_picked_pris_per_turn + 1
	
	# if we've picked as many as possible
	if next_picked_pris >= IVPrisonerSpawner.max_picked_pris_per_turn :
		# INITATE NEXT TURN
		GLCellManagerBus.emit_signal('delete_remaining_prisoners')
		IVPrisonerSpawner.curr_picked_pris_per_turn = 0
	else :
		IVPrisonerSpawner.curr_picked_pris_per_turn = next_picked_pris
	
func _handle_finale_turn() : 
	finale_round_loop_active = true
	
func _handle_next_round() :
	finale_round_loop_active = false
	# reset this incase player left non-picked prisoners
	IVPrisonerSpawner.curr_picked_pris_per_turn = 0
		
	

	
	
