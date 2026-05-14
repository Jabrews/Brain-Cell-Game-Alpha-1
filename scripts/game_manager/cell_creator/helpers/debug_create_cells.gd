class_name DEBUGCreateCells

# components
var name_manager : Node

func _init(new_name_manager) : 
	self.name_manager = new_name_manager
	
func create_prisoner_cells() -> Array[BrainCell]: 
	
	# create 4 prisoner	
	var new_prisoners : Array[BrainCell]= []
	var pris_max = 4	
	var i = 0
	
	while i != pris_max:
		
		var new_name = name_manager.pick_prisoner_names()
		
		var new_prisoner = BrainCell.new(
			new_name,
			10,
			10,
			10,
			1,
			5,
			5,
			5,
			true,
		)
		
		new_prisoners.append(new_prisoner)
		
		i += 1
	
	return new_prisoners
	
func create_target_cell() -> BrainCell: 
	
	var new_name = name_manager.pick_target_names()
	
	var test_target = BrainCell.new(
		new_name,
		20,
		20,
		20,
		1000,
		0,
		0,
		0,
		false,
		false,
		false,
		true,
	)	

	return test_target
		
	
	
	
