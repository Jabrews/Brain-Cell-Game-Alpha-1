extends Node

# components helpers
@onready var create_clean_stats : Node = $StatHelpers/HelperCreateClean
@onready var create_defect_stats : Node = $StatHelpers/HelperCreateDefect
@onready var create_hidden_stats : Node = $HelperHidden
# offer helpers
@onready var offer_five : Node = $OfferHelpers/OfferFive

func assemble(cell_constructor : CellConstructor) -> Array[BrainCell]:

	var prisoner_cells : Array[BrainCell] = []

	for i in range(cell_constructor.cell_quantity):

		### CLEAN STATS ###
		var clean_strength : BrainCellStat= create_clean_stats._create(
			cell_constructor.strength
		)

		var clean_intelligence : BrainCellStat = create_clean_stats._create(
			cell_constructor.intelligence
		)

		var clean_community : BrainCellStat = create_clean_stats._create(
			cell_constructor.community
		)
		####################

		### ESC ###
		var new_name = GAMENameManager.pick_prisoner_names()
		var life_span = randi_range(2, 4)
		###########

		var new_prisoner_cell = BrainCell.new(
			new_name,
			clean_strength,
			clean_intelligence,
			clean_community,
			life_span,
		)
	
		### DEFECT STATS ###
		var defect_strength = create_defect_stats._create(
			new_prisoner_cell.strength,
			cell_constructor.strength.spare_symbol,
		)
		new_prisoner_cell.strength.defect = defect_strength		
		
		var defect_intelligence = create_defect_stats._create(
			new_prisoner_cell.intelligence,
			cell_constructor.intelligence.spare_symbol,
		)
		new_prisoner_cell.intelligence.defect = defect_intelligence 
		
		var defect_community = create_defect_stats._create(
			new_prisoner_cell.community,
			cell_constructor.community.spare_symbol,
		)
		new_prisoner_cell.community.defect = defect_community 
		####################
		prisoner_cells.append(new_prisoner_cell)
	
	
	#### HIDDEN STATS ####
	
	prisoner_cells = create_hidden_stats._handle_hidden(cell_constructor, prisoner_cells)

	######################


	return prisoner_cells
		
		
	
##
