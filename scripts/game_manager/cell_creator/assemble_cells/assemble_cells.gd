extends Node

# components
@onready var name_manager : Node = $"../NameManager"

# components helpers
@onready var create_clean_stats : Node = $StatHelpers/HelperCreateClean
@onready var create_defect_stats : Node = $StatHelpers/HelperCreateDefect
@onready var create_hidden_stats : Node = $HiddenStatHelpers/HelperHidden
@onready var hidden_defect_trap : Node = $HiddenStatHelpers/HelperHiddenDefectTrap
# offer helpers
@onready var offer_five : Node = $OfferHelpers/OfferFive

func assemble(cell_constructor : CellConstructor) -> Array[BrainCell]:

	var prisoner_cells : Array[BrainCell] = []

	for i in range(cell_constructor.cell_quantity):

		var clean_strength : BrainCellStat= create_clean_stats._create(
			cell_constructor.strength
		)

		var clean_intelligence : BrainCellStat = create_clean_stats._create(
			cell_constructor.intelligence
		)

		var clean_community : BrainCellStat = create_clean_stats._create(
			cell_constructor.community
		)

		var new_name = name_manager.pick_prisoner_names()
		var life_span = randi_range(2, 4)

		var new_prisoner_cell = BrainCell.new(
			new_name,
			clean_strength,
			clean_intelligence,
			clean_community,
			life_span,
		)

		prisoner_cells.append(new_prisoner_cell)


	return prisoner_cells
		
		
		
		
		
	
	
	
	#var current_round : int = GLGameManagerBus.current_round
	
	#var cell_contructors : Array[CellConstructor] = constructer_manager.get_cell_constructor(current_round)
	
	#var new_prisoner_cells : Array[BrainCell]
	
	# verify clean stat due order beforeCreated going foward
	
	## offer 5 
	# reduce amount of hidden stats by half. starting with best constructors
	#if GLShareholderOfferState.offer_5_active :
		##cell_contructors = offer_five.handle_offer_5(cell_contructors)
#
	#for contructor : CellConstructor in cell_contructors :
		#var new_cells : Array[BrainCell] = create_cells_with_constructor(contructor)				
		#for cell in new_cells :
			#new_prisoner_cells.append(cell)
	#
	## handle defect traps
	#new_prisoner_cells = hidden_defect_trap._handle_hidden_stat_defect_trap_event(new_prisoner_cells)
	#
	#new_prisoner_cells.shuffle()
			#
	#return new_prisoner_cells
		#
#
#func create_cells_with_constructor(constructor : CellConstructor):
#
	## loop through quantity for constructor amount
	#var cell_index : int = 0
	#
	#var new_prisoner_cells : Array[BrainCell]
#
	#while cell_index < constructor.cell_quantity:
		#
		#var clean_stats : Array[float] = create_clean_stats._create(constructor.clean_ranges)
		#var defect_stats : Array[float] = create_defect_stats._create(cell_index, constructor, clean_stats)
		#

		#
		#var new_name =  name_manager.pick_prisoner_names()
		#var new_prisoner_cell = BrainCell.new(
			#new_name,
			#clean_stats[0],
			#clean_stats[1],
			#clean_stats[2],
			#life_span,
			#defect_stats[0],
			#defect_stats[1], 
			#defect_stats[2],
			#false,
			#false,
			#false,
		#)
#
		#new_prisoner_cells.append(new_prisoner_cell)
#
		#cell_index += 1
		#
	## do hidden stats		
	#new_prisoner_cells = create_hidden_stats._handle_hidden(constructor, new_prisoner_cells)
	#
	## return finale quanity
	#return new_prisoner_cells
		#
	#
	#
##
