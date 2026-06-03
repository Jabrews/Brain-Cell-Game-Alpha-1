extends Node

# component helpers
@export var name_manager : Node 
@onready var clean_stat_helper : Node = $CleanStatHelper
@onready var defect_stat_helper : Node = $DefectStatHelper


func _ready() -> void:
	connect_signals()
	create_class_refrences()

##### INIT HELPERS #####
func connect_signals() : 
	GLCellBreederBus.connect('player_breeded_cells', _handle_player_breeded_cells)

func create_class_refrences() : 
	pass
########################

func _handle_player_breeded_cells(cell_1 : BrainCell, cell_2 : BrainCell) : 
	
	# [strength, intelligence, community]
	var clean_stat_array = clean_stat_helper.generate_clean_stats(cell_1, cell_2)
	var defect_stat_array = defect_stat_helper.generate_defect_stats(cell_1, cell_2)
	
	var new_name = name_manager.pick_prisoner_names()
	
	# create stats
	var strength_stat = BrainCellStat.new(
		'strength', 
		true,
		clean_stat_array[0],
		defect_stat_array[0],
		false
	)
	var intelligence_stat = BrainCellStat.new(
		'intelligence', 
		true,
		clean_stat_array[1],
		defect_stat_array[1],
		false
	)
	var community_stat = BrainCellStat.new(
		'community', 
		true,
		clean_stat_array[2],
		defect_stat_array[2],
		false
	)
	
	# create object
	var new_cell = BrainCell.new(
		new_name,
		strength_stat,
		intelligence_stat,
		community_stat,
		3, #lifespan		
	)
	
	# check for disabled stats. pass to object
	if new_cell.strength.value == 0 :
		new_cell.strength.enabled = false
		new_cell.strength.defect = 0
		
	if new_cell.intelligence.value == 0 :
		new_cell.intelligence.enabled = false
		new_cell.intelligence.defect = 0	
		
	if new_cell.community.value == 0 :
		new_cell.community.enabled = false
		new_cell.community.defect = 0

	GLCellManagerBus.emit_signal('cell_breeded', cell_1, cell_2, new_cell)
