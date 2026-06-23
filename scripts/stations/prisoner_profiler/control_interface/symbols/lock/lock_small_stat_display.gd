extends Node

@onready var small_stat_display : Node2D = $"../../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay"
@onready var small_stat_lock_bg : ColorRect = $"../../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/Locked/LockedBG"
@onready var handle_lock_parent : Node = $".."

func update_small_stat_display_lock() :
	if small_stat_display.selected_stat_type != '' :
		small_stat_display_get_lock(small_stat_display.selected_stat_type )

func small_stat_display_get_lock(stat_type : String) :
#	
	var max_value: float = IVCellCreator.max_stat_value
	var total_stat_value: float = IVCellCreator.total_stat_value
	var max_width: float = 840.0
	
	var stat_lock_percantages: Array[float] = IVPrisonerProfiler.stat_lock_percantages
	
	if stat_lock_percantages.is_empty():
		push_error("stat_lock_percantages is empty.")
		return
	
	var selected_index : int = 0
	
	match stat_type :
		'strength' :
			selected_index = IVPrisonerProfiler.strength_stat_lock_percant_index
		'intelligence' :
			selected_index = IVPrisonerProfiler.intelligence_stat_lock_percant_index
		'community' :
			selected_index = IVPrisonerProfiler.community_stat_lock_percant_index
	
	var _unused_value = handle_lock_parent._generate_single_lock(
		small_stat_lock_bg,
		selected_index,
		stat_lock_percantages,
		max_value,
		total_stat_value,
		max_width
	)
	
