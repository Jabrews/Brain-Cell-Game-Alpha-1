extends Node
#
#
func _handle_hidden_stat_defect_trap_event(
	new_prisoners : Array[BrainCell],
) :
	print('no done yet')
	return new_prisoners
	#
	### case 5 ##
	## this case will add more defect trap stats. 
	#if GLShareholderOfferState.offer_5_active  :
		#if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			#print_debug('offer 5')
		#handle_offer_5_traps(new_prisoners)
		#return new_prisoners
	#
	#
	#
	## if prisoner selection isnt 2 no trap
	#if IVPrisonerSpawner.max_picked_pris_per_turn != 2 :
		#return new_prisoners 
	#
	## if round isnt 2, 3, or 4
	#if GLGameManagerBus.current_round != 2 \
	#and GLGameManagerBus.current_round != 3 \
	#and GLGameManagerBus.current_round != 4:
		#return new_prisoners
	#
	## if turn isnt atleast 2
	#if GLGameManagerBus.current_turn < 2 :
		#return new_prisoners
		#
	## random chance to leave
	#var ran_num = randi_range(0, 100)
	#if ran_num <= 50 :
		#return new_prisoners
	#
	#var trap_candidate_cells : Array = find_cell_candidates(new_prisoners)
	#
	## no valid candidates
	#if len(trap_candidate_cells) == 0 :
		#print('no candidate found')
		#return new_prisoners
		#
	#### offer five ##
	### reduce amount of hidden stats to hide. BUT we increase amount of hidden bombs. always atleast 1-2
	#if GLShareholderOfferState.offer_5_active:
		#if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			#print_debug('offer 5')
		#print('trap candiate cell amount : ', len(trap_candidate_cells))		
		#var cell_1_candidate = trap_candidate_cells.pick_random()
		#print('chose offer 4 bomb candiate', cell_1_candidate['cell'].name)
		#trap_candidate_cells.erase(cell_1_candidate)	
		#var cell_2_candidate = trap_candidate_cells.pick_random()
		#print('chose offer 4 bomb candiate', cell_1_candidate['cell'].name)
		#trap_candidate_cells.erase(cell_2_candidate)		
		#plant_candidate_trap(new_prisoners, cell_1_candidate)
		#plant_candidate_trap(new_prisoners, cell_2_candidate)
		#print('planted traps')		
		#return new_prisoners
	##############
		#
	#
	#var best_candidate = get_best_candidate(trap_candidate_cells)
	#
	## somehow no best candidate
	#if not best_candidate :
		#return new_prisoners
	#
	#new_prisoners = plant_candidate_trap(new_prisoners, best_candidate)
	#
	#return new_prisoners
#
#
#
#func find_cell_candidates(new_prisoners : Array[BrainCell]) -> Array:
	#
	#var trap_candidate_cells = []
	#
	## go through cells in new_prisoners
	#for cell : BrainCell in new_prisoners :
		#
		### NO ACCEPT CASES ##
		#
		## if cell doesnt have atleast one hidden stat skip
		#if cell.strength_hidden == false \
		#and cell.intelligence_hidden == false \
		#and cell.community_hidden == false :
			#continue
		#
		## cant add fully hidden cell
		#if cell.strength_hidden == true \
		#and cell.intelligence_hidden == true \
		#and cell.community_hidden == true :
			#continue
			#
		### CELL CANDIDATE POINTS ##
		#var total_candidate_points : float = 0.0
#
		## strength
		#if not cell.strength_hidden :
			#total_candidate_points += cell.strength.value* 5
			#total_candidate_points -= cell.strength_defect * 3
#
		## intelligence
		#if not cell.intelligence_hidden :
			#total_candidate_points += cell.intelligence.value * 5
			#total_candidate_points -= cell.intelligence_defect * 3
#
		## community
		#if not cell.community_hidden :
			#total_candidate_points += cell.community * 5
			#total_candidate_points -= cell.community_defect * 3
			#
		### ADD CANDIDATE OBJECT ##
		#var candidate_obj = {
			#'cell' : cell,
			#'points' : total_candidate_points
		#}
		#
		#trap_candidate_cells.append(candidate_obj)
		#
	## finally return
	#return trap_candidate_cells
		#
		#
	#
#func get_best_candidate(trap_candidate_cells : Array) :
	#
	## no candidates
	#if len(trap_candidate_cells) == 0 :
		#return null
	#
	## sort highest points first
	#trap_candidate_cells.sort_custom(func(a, b):
		#return a['points'] > b['points']
	#)
	#
	## if only 1 candidate return it
	#if len(trap_candidate_cells) == 1 :
		#return trap_candidate_cells[0]
	#
	## 35% chance to pick second best
	#var ran_num = randi_range(0, 100)
	#
	#if ran_num <= 35 :
		#return trap_candidate_cells[1]
	#
	## otherwise return best
	#return trap_candidate_cells[0]
			#
	#
#func plant_candidate_trap(new_prisoners : Array[BrainCell], best_candidate) :
	#
	#var candidate_cell : BrainCell = best_candidate['cell']
	#
	## randomly choose one hidden stat to increase defect on
	#var hidden_stats = []
	#
	#if candidate_cell.strength_hidden :
		#hidden_stats.append('strength')
	#
	#if candidate_cell.intelligence_hidden :
		#hidden_stats.append('intelligence')
	#
	#if candidate_cell.community_hidden :
		#hidden_stats.append('community')
	#
	## no hidden stats somehowi w
	#if len(hidden_stats) == 0 :
		#return new_prisoners
	#
	#var random_hidden_stat = hidden_stats.pick_random()
	#
	## increase defect by 50%
	#### NEVER SURPASS 20 POINTS - MAX_STAT_VALUE
	#match random_hidden_stat :
		#
		#'strength' :
			#
			#candidate_cell.strength_defect += (
				#IVCellCreator.max_stat_value * .40
			#)
			#
			#candidate_cell.strength_defect = min(
				#candidate_cell.strength_defect,
				#IVCellCreator.max_stat_value - 20
			#)
		#
		#'intelligence' :
			#
			#candidate_cell.intelligence_defect += (
				#IVCellCreator.max_stat_value * .40
			#)
			#
			#candidate_cell.intelligence_defect = min(
				#candidate_cell.intelligence_defect,
				#IVCellCreator.max_stat_value - 20
			#)
			#
		#'community' :
			#
			#candidate_cell.community_defect += (
				#IVCellCreator.max_stat_value * .40
			#)
			#
			#candidate_cell.community_defect = min(
				#candidate_cell.community_defect,
				#IVCellCreator.max_stat_value - 20
			#)
			#
		#
	#
	#print(
		#'planted hidden defect trap on cell : ',
		#candidate_cell.name,
		#' hidden stat : ',
		#random_hidden_stat
	#)
	#
	## update new_prisoners with correct candidate cell update
	#for i in range(len(new_prisoners)) :
		#
		#if new_prisoners[i].name == candidate_cell.name :
			#new_prisoners[i] = candidate_cell
			#break
	#
	#return new_prisoners
#
#func handle_offer_5_traps(new_prisoners : Array[BrainCell]) :
#
	#var total_hidden_stats : int = 0
#
	## count hidden stats across all prisoners
	#for cell : BrainCell in new_prisoners:
#
		#if cell.strength_hidden:
			#total_hidden_stats += 1
#
		#if cell.intelligence_hidden:
			#total_hidden_stats += 1
#
		#if cell.community_hidden:
			#total_hidden_stats += 1
#
	#print("offer 5 total hidden stats : ", total_hidden_stats)
#
	## determine trap count
	#var trap_count : int = 0
#
	#if total_hidden_stats == 1:
		#trap_count = 1
#
	#elif total_hidden_stats == 2:
		#trap_count = 1 + int(randi_range(1, 100) <= 25)
#
	#elif total_hidden_stats > 2:
		#trap_count = 2 - int(randi_range(1, 100) <= 25)
#
	#var trap_candidate_cells : Array = find_cell_candidates(new_prisoners)
#
	#if len(trap_candidate_cells) == 0:
		#print("offer 5 no trap candidates")
		#return new_prisoners
#
	#for i in range(trap_count):
#
		#if len(trap_candidate_cells) == 0:
			#break
#
		#var selected_candidate = trap_candidate_cells.pick_random()
#
		#print(
			#"offer 5 selected cell : ",
			#selected_candidate["cell"].name
		#)
#
		#trap_candidate_cells.erase(selected_candidate)
#
		#new_prisoners = plant_candidate_trap(
			#new_prisoners,
			#selected_candidate
		#)
#
	#return new_prisoners
	#
