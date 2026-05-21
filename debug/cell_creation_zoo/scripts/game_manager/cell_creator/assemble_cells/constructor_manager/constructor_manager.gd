extends Node

var round_1 : Round1CellConstructors
var round_2 : Round2CellConstructors
var round_3 : Round3CellConstructors
var round_4 : Round4CellConstructors

func _ready() -> void:
	round_1 = Round1CellConstructors.new()
	round_2 = Round2CellConstructors.new()
	round_3 = Round3CellConstructors.new()
	round_4 = Round4CellConstructors.new()

@warning_ignore("shadowed_global_identifier")
func get_cell_constructor(round : int, turn : int) -> Array[CellConstructor]:
	
	var constructors : Array[CellConstructor]

	match round:
		
		
		1:
			if turn == 0 :
				print("DEBUG : construct_manager. we are setting breeding incr. values here")
				IVCellBreeding.max_cell_breeding_attempts = 5
				IVCellBreeding.curr_cell_breeding_attempt = 0
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				## TURNS 
				GLGameManagerBus.max_turns = 4
				GLGameManagerBus.current_turn = 0
				
				constructors = round_1.turn_0
			elif turn == 1 :
				constructors = round_1.turn_1
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 1
			elif turn == 2 : 
				constructors = round_1.turn_2
				IVPrisonerSpawner.max_picked_pris_per_turn = 1			
				GLGameManagerBus.current_turn = 2			
			elif turn == 3: 
				constructors = round_1.turn_3
				IVPrisonerSpawner.max_picked_pris_per_turn = 1			
				GLGameManagerBus.current_turn = 3
			elif turn == 4 :
				constructors = round_1.turn_4
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
				
		2 : 
			if turn == 0 :
				IVCellBreeding.max_cell_breeding_attempts = 5
				IVCellBreeding.curr_cell_breeding_attempt = 0
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.max_turns = 4
				constructors = round_2.turn_0
				GLGameManagerBus.current_turn = 0
			elif turn == 1 :
				constructors = round_2.turn_1
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 1
			elif turn == 2 : 
				constructors = round_2.turn_2
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 2
			elif turn == 3: 
				constructors = round_2.turn_3
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 3			
			elif turn == 4 :
				constructors = round_2.turn_4
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
				
		3 :
			if turn == 0 :
				IVCellBreeding.max_cell_breeding_attempts = 6
				IVCellBreeding.curr_cell_breeding_attempt = 0
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.max_turns = 5
				GLGameManagerBus.current_turn = 0
				constructors = round_3.turn_0
			elif turn == 1 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 1
				constructors = round_3.turn_1
			elif turn == 2 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 2			
				constructors = round_3.turn_2	
			elif turn == 3: 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 3
				constructors = round_3.turn_2
			elif turn == 4 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
				constructors = round_3.turn_3
			elif turn == 5 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 5
				constructors = round_3.turn_4
		4 : 
			if turn == 0 :
				IVCellBreeding.max_cell_breeding_attempts = 7
				IVCellBreeding.curr_cell_breeding_attempt = 0
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.max_turns = 5
				GLGameManagerBus.current_turn = 0
				constructors = round_4.turn_0
			elif turn == 1 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 1
				constructors = round_4.turn_1
			elif turn == 2 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 1
				GLGameManagerBus.current_turn = 2
				constructors = round_4.turn_2
			elif turn == 3: 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 3
				constructors = round_4.turn_3
			elif turn == 4 :
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 4
				constructors = round_4.turn_4
			elif turn == 5 : 
				IVPrisonerSpawner.max_picked_pris_per_turn = 2
				GLGameManagerBus.current_turn = 5			
				constructors = round_4.turn_5

	return constructors
