extends Node

# componnets
@onready var name_manager : Node = $"../NameManager"
@onready var cell_manager


func assemble() :

	var max_stat_value = IVCellCreator.max_stat_value
	
	var target_strength = randi_range(max_stat_value * 0.80, max_stat_value)
	var target_intelligence = randi_range(max_stat_value * 0.80, max_stat_value )
	var target_community = randi_range(max_stat_value * 0.80, max_stat_value )
	
	var new_name = name_manager.pick_target_names()
	
	var target_cell : BrainCell = BrainCell.new(
		new_name,
		target_strength,
		target_intelligence,
		target_community,
		1000,
		0,
		0,
		0,
		false,
		false,
		false,
		true, # is target cell
	)
	
	return target_cell
	
	
	
	
	
	
	
	
	
