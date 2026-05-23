extends Node

var round_incr_values_set = false
var last_round : int = 0

func _ready() -> void:
	# this is only called by round manager station in creation zoo 
	GLIncrementalValueControllerBus.connect('progression_change', change_progression_step)


@warning_ignore("shadowed_global_identifier") # FUCK THIS WTF 
func change_progression_step(round : int, turn : int) :

	if last_round != round :
		handle_round(round)
		last_round = round
	
	handle_turns(round, turn)
	
	

@warning_ignore("shadowed_global_identifier")
func handle_round(round : int):

	match round :
		1 : 
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
			## TURNS  ##
			GLGameManagerBus.max_turns = 4
			GLGameManagerBus.current_turn = 0
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 5
			IVCellBreeding.curr_cell_breeding_attempt = 0		
			## BREEDING SCALING ##
			IVCellBreeding.low_add_percant_scale = 0.6			
			IVCellBreeding.high_add_percant_scale = 0.5
			IVCellBreeding.low_subtract_percant_scale = 0.7
			IVCellBreeding.high_subtract_percant_scale = 0.6
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 160
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 30
		2 : 

			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
			## TURNS ##
			GLGameManagerBus.max_turns = 4
			GLGameManagerBus.current_turn = 0
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 5
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## BREEDING SCALING ##
			IVCellBreeding.low_add_percant_scale = 0.7
			IVCellBreeding.high_add_percant_scale = 0.6
			IVCellBreeding.low_subtract_percant_scale = 0.8
			IVCellBreeding.high_subtract_percant_scale = 0.7
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 230
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 45
		3 : 
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = true 
			## TURNS ##
			GLGameManagerBus.max_turns = 5
			GLGameManagerBus.current_turn = 0
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 6
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 320
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 60
		4 : 
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = true 
			## TURNS ##
			GLGameManagerBus.max_turns = 5
			GLGameManagerBus.current_turn = 0
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 7
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 400
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 75
	
@warning_ignore("shadowed_global_identifier")
func handle_turns(round : int, turn : int) :
	
	match  round :
		1 :
			if turn == 0 :
				GLGameManagerBus.current_turn = 0
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
			elif turn == 1 :
				GLGameManagerBus.current_turn = 1
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
			elif turn == 2 :
				GLGameManagerBus.current_turn = 2
				IVPrisonerSpawner.max_picked_pris_per_turn = 1			
			elif turn == 3 :
				GLGameManagerBus.current_turn = 3
				IVPrisonerSpawner.max_picked_pris_per_turn = 1			
			elif turn == 4 :
				GLGameManagerBus.current_turn = 4
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
		2 : 
			if turn == 0 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 0
			elif turn == 1 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 1
			elif turn == 2 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 2
			elif turn == 3: 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 3			
			elif turn == 4 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
				
		3 : 	
			if turn == 0 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 0
			elif turn == 1 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 1
			elif turn == 2 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 2			
			elif turn == 3: 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 3
			elif turn == 4 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
			elif turn == 5 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 5
				
		4 : 
			if turn == 0 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 0
			elif turn == 1 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 1
			elif turn == 2 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 2
			elif turn == 3: 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 3
			elif turn == 4 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
			elif turn == 5 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 5			
	
	
	
	
	
	
	
