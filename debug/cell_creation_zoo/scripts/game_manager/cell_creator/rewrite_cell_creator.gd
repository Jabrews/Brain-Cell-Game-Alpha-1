extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var name_manager : Node = $NameManager
@onready var observe_player_hand : Node = $ObservePlayerHand

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
	
	var creation_case = observe_player_hand.find_case()
	
	# if target_included also add to manager
	
	#if include_target :
		#var new_target_cell = debug_create_cells.create_target_cell()
		#cell_manager.set_target_cell(new_target_cell)
		#GLCellCreatorBus.emit_signal('get_newest_target_cell', new_target_cell)
	
	# create and update prisoner cells
			
	
	#new_prisoner_cells = debug_create_cells.create_prisoner_cells()
	#cell_manager.set_prisoner_cells(new_prisoner_cells)
	#GLCellCreatorBus.emit_signal('get_newest_prisoner_cells', new_prisoner_cells)
	
	
	
	
	
	
	
