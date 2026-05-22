extends Node

# components
@onready var constructer_manager : Node = $ConstructorManager
@export var name_manager : Node

# components helpers
@onready var create_clean_stats : Node = $HelperCreateClean
@onready var create_defect_stats : Node = $HelperCreateDefect
@onready var create_hidden_stats : Node = $HelperHidden
@onready var clean_stat_due_order : Node = $HelperCleanStatDueOrder

func assemble() :
	var current_round : int = GLGameManagerBus.current_round
	var current_turn : int = GLGameManagerBus.current_turn
	
	var cell_contructors : Array[CellConstructor] = constructer_manager.get_cell_constructor(current_round, current_turn)
	
	var new_prisoner_cells : Array[BrainCell]
	
	# verify clean stat due order before going foward
	cell_contructors = clean_stat_due_order._verify_user_clean_stat_due_order(cell_contructors)
	
	
	
	for contructor : CellConstructor in cell_contructors :
		var new_cells : Array[BrainCell] = create_cells_with_constructor(contructor)				
		for cell in new_cells :
			new_prisoner_cells.append(cell)
		
	new_prisoner_cells.shuffle()
			
	return new_prisoner_cells
		

func create_cells_with_constructor(constructor : CellConstructor):

	# loop through quantity for constructor amount
	var cell_index : int = 0
	
	var new_prisoner_cells : Array[BrainCell]

	while cell_index < constructor.cell_quantity:
		
		var clean_stats : Array[float] = create_clean_stats._create(constructor.clean_ranges)
		var defect_stats : Array[float] = create_defect_stats._create(cell_index, constructor, clean_stats)
		
		var new_name =  name_manager.pick_prisoner_names()
		var new_prisoner_cell = BrainCell.new(
			new_name,
			clean_stats[0],
			clean_stats[1],
			clean_stats[2],
			3,
			defect_stats[0],
			defect_stats[1], 
			defect_stats[2],
			false,
			false,
			false,
		)

		new_prisoner_cells.append(new_prisoner_cell)

		cell_index += 1
		
	# do hidden stats		
	new_prisoner_cells = create_hidden_stats._handle_hidden(constructor, new_prisoner_cells)
	
	# return finale quanity
	return new_prisoner_cells
		
	
	
#
