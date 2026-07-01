extends Node

var round_incr_values_set = false
var last_round : int = 0

# components
@onready var iv_helper_defect_event : Node = $IVHelperDefectEvent
@onready var iv_helper_hidden_stats : Node = $IVHelperHiddenStats
@onready var iv_helper_profiler_spare_progression : Node = $IVHelperProfilerSpareProgression
@onready var iv_helper_cell_stat_creation : Node = $IVHelperCellStatCreation
@onready var iv_helper_shareholder_items : Node = $IVHelperShareholderItems

func _ready() -> void:
	# when energy changes outside of prisoner generation
	# ex. cell defector decrease station
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)


@warning_ignore("shadowed_global_identifier") # FUCK THIS WTF
func change_progression_step(round : int, curr_energy: int) :
	
	if last_round != round :
		handle_round(round)
		
		# any event calls
		GLUsableItemBus.emit_signal('spawn_new_usable_items')
		GLGameManagerBus.emit_signal('process_next_round')
		
		last_round = round
	
	
	handle_energy(round, GLGameManagerBus.curr_energy)
	
	
	GLGameManagerBus.emit_signal('proceed_next_energy_turn')
	

@warning_ignore("shadowed_global_identifier")
func handle_round(round : int):
	
	match round :
		1 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
			# ENERGY ##
			GLGameManagerBus.curr_energy = 100
			GLGameManagerBus.max_energy = 100
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
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_energy_percant= 75
			IVShareholderOffers.first_round_item_offer_energy_percant = 40
			## HIDDEN STATS ## 
			IVHiddenStats.stats_to_hide = []
			## PRISONER PROFILER ##
			IVPrisonerProfiler.stat_increment_amount = 10
			IVPrisonerProfiler.strength_stat_lock_percant_index = 0
			IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
			IVPrisonerProfiler.community_stat_lock_percant_index= 0
			IVPrisonerProfiler.stat_lock_percantages = [0.35, 0.55, 0.80, 1.01,]			
			IVPrisonerProfiler.per_stat_increment_energy_decrease = 1
			## DEFECT DECREASER ##
			IVCellDefectDecreaser.station_enabled = false
			
		2 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
			## ENERGY ##
			GLGameManagerBus.curr_energy = 120
			GLGameManagerBus.max_energy = 120
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
			IVUseableItemSpawner.defect_shots_to_spawn = 0
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 0
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_energy_percant= 75
			## HIDDEN STATS ## 
			IVHiddenStats.stats_to_hide = ['strength']
			## PRISONER PROFILER ##
			IVPrisonerProfiler.stat_increment_amount = 10
			IVPrisonerProfiler.strength_stat_lock_percant_index = 0
			IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
			IVPrisonerProfiler.community_stat_lock_percant_index= 0
			IVPrisonerProfiler.stat_lock_percantages = [0.35, 0.55, 0.80, 1.01,]			
			IVPrisonerProfiler.per_stat_increment_energy_decrease = 1
			## DEFECT DECREASER ##
			IVCellDefectDecreaser.station_enabled = false
			
			
		3 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = true
			## ENERGY ##
			GLGameManagerBus.curr_energy = 130
			GLGameManagerBus.max_energy = 130
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 6
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 320
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 60
			IVUseableItemSpawner.defect_shots_to_spawn = 0
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 0
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			IVUseableItemSpawner.scissors_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_energy_percant= 75
			## HIDDEN STATS ## 
			IVHiddenStats.stats_to_hide = ['strength', 'intelligence']
			## PRISONER PROFILER ##
			IVPrisonerProfiler.stat_increment_amount = 20
			IVPrisonerProfiler.strength_stat_lock_percant_index = 0
			IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
			IVPrisonerProfiler.community_stat_lock_percant_index= 0
			IVPrisonerProfiler.stat_lock_percantages = [0.35, 0.55, 0.80, 1.01,]			
			IVPrisonerProfiler.per_stat_increment_energy_decrease = 2
			## DEFECT DECREASER ##
			IVCellDefectDecreaser.station_enabled = true
		4 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = true
			## ENERGY ##
			GLGameManagerBus.curr_energy = 150
			GLGameManagerBus.max_energy = 150
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 7
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 400
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 75
			IVUseableItemSpawner.defect_shots_to_spawn = 0
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 5
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.item_offer_energy_percant= 75
			## HIDDEN STATS ## 
			IVHiddenStats.stats_to_hide = ['strength', 'intelligence', 'community']
			## PRISONER PROFILER ##
			IVPrisonerProfiler.stat_increment_amount = 20
			IVPrisonerProfiler.strength_stat_lock_percant_index = 0
			IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
			IVPrisonerProfiler.community_stat_lock_percant_index= 0
			IVPrisonerProfiler.stat_lock_percantages = [0.35, 0.55, 0.80, 1.01,]			
			IVPrisonerProfiler.per_stat_increment_energy_decrease = 2
			## DEFECT DECREASER ##
			IVCellDefectDecreaser.station_enabled = true
	
@warning_ignore("shadowed_global_identifier")
func handle_energy(round : int, energy: int) :
	
	iv_helper_defect_event._update_defect_event_values(round, energy)
	iv_helper_hidden_stats._update_hidden_stat_values(round, energy)
	iv_helper_profiler_spare_progression._update_spare_progression(round, energy)
	iv_helper_cell_stat_creation._update_cell_stat_creation(round, energy)
	iv_helper_shareholder_items._update_shareholder_items(round, energy)
	

func _handle_energy_changed() :
	handle_energy(GLGameManagerBus.current_round, GLGameManagerBus.curr_energy)
