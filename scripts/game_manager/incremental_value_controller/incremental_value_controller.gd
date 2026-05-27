extends Node

var round_incr_values_set = false
var last_round : int = 0

# components
@onready var iv_helper_defect_event : Node = $IVHelperDefectEvent

func _ready() -> void:
	# this is only called by round manager station in creation zoo 
	GLIncrementalValueControllerBus.connect('progression_change', change_progression_step)


@warning_ignore("shadowed_global_identifier") # FUCK THIS WTF
func change_progression_step(round : int, turn : int) :

	if last_round != round :
		handle_round(round)
		
		# any event calls
		GLUsableItemBus.emit_signal('spawn_new_usable_items')
		
		last_round = round
	
	handle_turns(round, turn)
	
	# any event calls
	GLGameManagerBus.emit_signal('next_turn_process')
	
	

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
			IVCellBreeding.low_add_percant_scale = 0.9
			IVCellBreeding.high_add_percant_scale = 0.7
			IVCellBreeding.low_subtract_percant_scale = 0.9
			IVCellBreeding.high_subtract_percant_scale = 0.8
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 160
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 30
			IVUseableItemSpawner.defect_shots_to_spawn = 0
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_turn = 3
			IVShareholderOffers.stat_offer_turn = 2
			
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
			IVUseableItemSpawner.defect_shots_to_spawn = 1
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 5
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_turn = 3
			IVShareholderOffers.stat_offer_turn = 2
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
			IVUseableItemSpawner.defect_shots_to_spawn = 1
			IVUseableItemSpawner.hidden_shots_to_spawn = 1
			IVUseableItemSpawner.steroids_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_turn = 2
			IVShareholderOffers.stat_offer_turn = 3		
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
			IVUseableItemSpawner.defect_shots_to_spawn = 1
			IVUseableItemSpawner.hidden_shots_to_spawn = 2
			IVUseableItemSpawner.steroids_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_turn = 2
			IVShareholderOffers.stat_offer_turn = 3		
	
@warning_ignore("shadowed_global_identifier")
func handle_turns(round : int, turn : int) :
	
	# helpers
	iv_helper_defect_event.	update_defect_event_values(round, turn)
	
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
	
	
	
	
	
	
	
