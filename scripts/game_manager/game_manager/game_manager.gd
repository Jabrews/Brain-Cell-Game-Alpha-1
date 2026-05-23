extends Node

# components
@onready var cell_creator : Node = $CellCreator
@onready var cell_manager : Node = $CellManager


func _ready() : 
	connect_signals()
	create_class_refrences()

	GLCellCreatorBus.emit_signal('create_cells', true)
	
	
##### INIT HELPERS ######

func connect_signals() : 
	GLGameManagerBus.connect('attempt_next_turn', _handle_attempt_next_turn)
	GLGameManagerBus.connect('proceed_next_round', initate_next_round)

func create_class_refrences() : 
	pass

########################

func _handle_attempt_next_turn(): 
	var curr_turn = GLGameManagerBus.current_turn
	var max_turns = GLGameManagerBus.max_turns
	
	if curr_turn == max_turns - 1 :
		GLGameManagerBus.current_turn += 1
		GLGameManagerBus.emit_signal('finale_turn')
		initate_next_turn()
	else : 
		GLGameManagerBus.current_turn += 1
		initate_next_turn()

	
func initate_next_turn() : 
	GLCellCreatorBus.emit_signal('create_cells', false)

func initate_next_round() : 
	var curr_round = GLGameManagerBus.current_round
	var max_rounds = GLGameManagerBus.max_rounds
	
	if curr_round == max_rounds :
		push_error('GAME FINISHED')
		get_tree().current_scene.queue_free()
	
	# update round logic
	GLGameManagerBus.current_round += 1
	GLGameManagerBus.current_turn = 0
	
	# communicate to all components finale round loop ended 
	# (target_compare_station, prisoner_picker_station, breeding_station)
	GLGameManagerBus.emit_signal('finale_turn_ended_new_round_proceed')
	# delete all prior cells
	GLCellManagerBus.emit_signal('delete_cells_for_next_round')
	# create new cells
	GLCellCreatorBus.emit_signal('create_cells', true)
	



	
