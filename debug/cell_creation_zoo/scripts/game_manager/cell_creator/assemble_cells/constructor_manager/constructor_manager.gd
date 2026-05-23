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
				constructors = round_1.turn_0
			elif turn == 1 :
				constructors = round_1.turn_1
			elif turn == 2 : 
				constructors = round_1.turn_2
			elif turn == 3: 
				constructors = round_1.turn_3
			elif turn == 4 :
				constructors = round_1.turn_4
				
		2 : 
			if turn == 0 :
				constructors = round_2.turn_0
			elif turn == 1 :
				constructors = round_2.turn_1
			elif turn == 2 : 
				constructors = round_2.turn_2
			elif turn == 3: 
				constructors = round_2.turn_3
			elif turn == 4 :
				constructors = round_2.turn_4
				
		3 :
			if turn == 0 :
				constructors = round_3.turn_0
			elif turn == 1 :
				constructors = round_3.turn_1
			elif turn == 2 : 
				constructors = round_3.turn_2	
			elif turn == 3: 
				constructors = round_3.turn_2
			elif turn == 4 :
				constructors = round_3.turn_3
			elif turn == 5 : 
				constructors = round_3.turn_4
		4 : 
			if turn == 0 :
				constructors = round_4.turn_0
			elif turn == 1 :
				constructors = round_4.turn_1
			elif turn == 2 : 
				constructors = round_4.turn_2
			elif turn == 3: 
				constructors = round_4.turn_3
			elif turn == 4 :
				constructors = round_4.turn_4
			elif turn == 5 : 
				constructors = round_4.turn_5

	return constructors
