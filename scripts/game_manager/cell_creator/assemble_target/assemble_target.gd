extends Node

# componnets
@onready var cell_manager


func assemble() :

	var max_stat_value = IVCellCreator.max_stat_value

	var min_value = int(max_stat_value * 0.75)

	var target_strength_value = randi_range(min_value, max_stat_value)
	var target_intelligence_value = randi_range(min_value, max_stat_value)
	var target_community_value = randi_range(min_value, max_stat_value)
	
	var new_name = GAMENameManager.pick_target_names()
	
	var target_strength = BrainCellStat.new(
		'strength', 		
		true,
		target_strength_value,
		0.0,
		false,
	)
	var target_intelligence = BrainCellStat.new(
		'intelligence', 		
		true,
		target_intelligence_value,
		0.0,
		false,
	)
	var target_community = BrainCellStat.new(
		'community', 		
		true,
		target_community_value,
		0.0,
		false,
	)
	
	
	var target_cell : BrainCell = BrainCell.new(
		new_name,
		target_strength,
		target_intelligence,
		target_community,
		1000,
		true,
		false,
		false,
	)
	
	return target_cell
	
	
	
	
	
	
	
	
	
