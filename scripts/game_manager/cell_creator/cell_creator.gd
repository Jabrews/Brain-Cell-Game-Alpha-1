extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var assemble_cells : Node = $AssembleCells
@onready var assemble_target : Node = $AssembleTarget
@onready var incrmental_value_controller : Node = $"../IncrementalValueController"

# offer helpers
@onready var offer_one : Node = $OfferHelpers/OfferOne
@onready var offer_three : Node = $OfferHelpers/OfferThree

var current_cell_constructor : CellConstructor


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	GLCellCreatorBus.connect(
		"create_prisoner_cells",
		handle_create_prisoners
	)

	GLCellCreatorBus.connect(
		"create_target_cell",
		handle_create_target
	)

	GLShareholderOfferState.connect(
		"create_prisoner_cells_user_chose_shareholder_offer",
		_handle_create_prisoner_cells_user_chose_shareholder_offer
	)


func handle_create_target() -> void:
	var target_cell = assemble_target.assemble()
	cell_manager.set_target_cell(target_cell)


# signal create_prisoner_cells(cell_constructor : CellConstructor)
func handle_create_prisoners( cell_constructor : CellConstructor, prevent_update_incr_update : bool = false ) -> void:

	current_cell_constructor = cell_constructor
	

	if not prevent_update_incr_update:
		var curr_round = GLGameManagerBus.current_round
		var curr_energy = GLGameManagerBus.curr_energy

		incrmental_value_controller.change_progression_step(
			curr_round,
			curr_energy,
		)
		
			
	GLCellManagerBus.emit_signal('delete_remaining_prisoners')
	# let 

	var new_prisoner_cells : Array[BrainCell] = assemble_cells.assemble(cell_constructor)
	
	cell_manager.set_prisoner_cells(
		new_prisoner_cells
	)
	
	# call this after no shareholder offer interuption 
	GLPrisonerPicksBus.emit_signal('generate_next_max_prisoners_created')

	GLCellCreatorBus.emit_signal(
		"get_newest_prisoner_cells",
		new_prisoner_cells
	)

	# TODO FIX SHAREHOLDER OFFERs
	###### shareholder offers #####
	if GLShareholderOfferState.await_user_choose_shareholder_offer_before_create:
		return

	#new_prisoner_cells = offer_one.handle_offer_1(
		#new_prisoner_cells
	#)
#
	#new_prisoner_cells = offer_three.handle_offer_3(
		#new_prisoner_cells
	#)
	#################################




# called after user chooses an offer
func _handle_create_prisoner_cells_user_chose_shareholder_offer() -> void:

	GLShareholderOfferState.await_user_choose_shareholder_offer_before_create = false

	handle_create_prisoners(
		current_cell_constructor,
		true
	)
