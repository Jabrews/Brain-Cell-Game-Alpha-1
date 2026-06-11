extends Node

# component helpers
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

# no signal directly called by breeding station
func _handle_player_simulate_breeded_cells(cell_1 : BrainCell, cell_2 : BrainCell) -> BrainCell:
	return _create_breeded_cell(cell_1, cell_2, false)


func _handle_player_breeded_cells(cell_1 : BrainCell, cell_2 : BrainCell) -> void:
	
	var new_cell = _create_breeded_cell(cell_1, cell_2, true)

	GLCellManagerBus.emit_signal(
		'cell_breeded',
		cell_1,
		cell_2,
		new_cell
	)


func _create_breeded_cell(
	cell_1 : BrainCell,
	cell_2 : BrainCell,
	generate_name : bool = true
) -> BrainCell:
	
	
	var clean_stat_array = clean_stat_helper.generate_clean_stats(
		cell_1,
		cell_2
	)

	var defect_stat_array = defect_stat_helper.generate_defect_stats(
		cell_1,
		cell_2
	)

	var cell_name = "Simulation"

	if generate_name:
		cell_name = GAMENameManager.pick_prisoner_names()

	var new_cell = BrainCell.new(
		cell_name,
		_create_stat(
			"strength",
			clean_stat_array[0],
			defect_stat_array[0]
		),
		_create_stat(
			"intelligence",
			clean_stat_array[1],
			defect_stat_array[1]
		),
		_create_stat(
			"community",
			clean_stat_array[2],
			defect_stat_array[2]
		),
		3
	)

	_apply_disabled_stats(new_cell)

	return new_cell


func _create_stat(
	stat_type : String,
	clean_value : float,
	defect_value : float
) -> BrainCellStat:

	return BrainCellStat.new(
		stat_type,
		true,
		clean_value,
		defect_value,
		false
	)


func _apply_disabled_stats(cell : BrainCell) -> void:

	if cell.strength.value == 0:
		cell.strength.enabled = false
		cell.strength.defect = 0

	if cell.intelligence.value == 0:
		cell.intelligence.enabled = false
		cell.intelligence.defect = 0

	if cell.community.value == 0:
		cell.community.enabled = false
		cell.community.defect = 0
