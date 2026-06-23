extends Node

@onready var helper_lock_small_stat_display : Node = $"../LockSmallStatDisplay"
@onready var helper_handle_lock : Node = $".."

func _ready() -> void:
	GLCellManagerBus.connect('cell_added_to_collection', _handle_cell_added_to_collection)	
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	
	
func _handle_cell_added_to_collection(new_cell : BrainCell) :
	check_for_stats_past_lock(new_cell)
	update_locks()

func _handle_cell_breeded(_cell_1, _cell_2, new_cell : BrainCell) :
	check_for_stats_past_lock(new_cell)
	update_locks()
	
func get_new_lock_index(curr_index : int, stat_value : float) -> int:
	var stat_lock_percants = IVPrisonerProfiler.stat_lock_percantages
	var max_stat_value : int = IVCellCreator.max_stat_value
	
	while curr_index < stat_lock_percants.size():
		var lock_min : float = max_stat_value * stat_lock_percants[curr_index]
		
		if stat_value <= lock_min:
			break
		
		curr_index += 1
	
	return curr_index
	
func check_for_stats_past_lock(new_cell : BrainCell) -> void: 	
	IVPrisonerProfiler.strength_stat_lock_percant_index = get_new_lock_index(
		IVPrisonerProfiler.strength_stat_lock_percant_index,
		new_cell.strength.value
	)
	
	IVPrisonerProfiler.intelligence_stat_lock_percant_index = get_new_lock_index(
		IVPrisonerProfiler.intelligence_stat_lock_percant_index,
		new_cell.intelligence.value
	)
	
	IVPrisonerProfiler.community_stat_lock_percant_index = get_new_lock_index(
		IVPrisonerProfiler.community_stat_lock_percant_index,
		new_cell.community.value
	)
		
func update_locks() :
	helper_handle_lock._generate_locks()
	helper_lock_small_stat_display.update_small_stat_display_lock()
		
	
	
