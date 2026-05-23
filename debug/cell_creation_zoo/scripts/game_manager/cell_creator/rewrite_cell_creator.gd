extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var name_manager : Node = $NameManager
@onready var observe_player_hand : Node = $ObservePlayerHand
@onready var assemble_cells : Node = $AssembleCells
@onready var incrmental_value_controller : Node = $"../IncrementalValueController"

# class helpers
var debug_create_cells : DEBUGCreateCells
#var player_hand_observer : PlayerHandObserver

func _ready() -> void:
	connect_signals()
	create_class_refrences()
	

##### INIT HELPERS #####
func connect_signals() : 
	GLCellCreatorBus.connect('create_cells', handle_create_cells)

func create_class_refrences() : 
	debug_create_cells = DEBUGCreateCells.new(name_manager)
########################
	
func handle_create_cells(_include_target : bool = false) -> void:
	
	# update incremental values
	var curr_round = GLGameManagerBus.current_round
	var curr_turn = GLGameManagerBus.current_turn
	incrmental_value_controller.change_progression_step(curr_round, curr_turn)
	
	var new_prisoner_cells : Array[BrainCell]
	var creation_case = observe_player_hand.find_case()
	
	if creation_case == 'none' :
		new_prisoner_cells = assemble_cells.assemble()
	
	cell_manager.set_prisoner_cells(new_prisoner_cells)
	GLCellCreatorBus.emit_signal('get_newest_prisoner_cells', new_prisoner_cells)
	
	
	
	
	
	
	
	
