extends Node

@onready var parent_station : Node3D = $"../../.."
@onready var lock_backgrounds : Array[ColorRect] = [
	$"../../../StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Locked/LockedBG",
	$"../../../StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Locked/LockedBG",
	$"../../../StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Locked/LockedBG",
	$"../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/Locked/LockedBG",
]
@onready var help_lock_small_stat_display : Node = $LockSmallStatDisplay


#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') :
		#IVPrisonerProfiler.strength_stat_lock_percant_index += 1
		#_generate_locks()
	#if Input.is_action_just_pressed('debug2') :
		#IVPrisonerProfiler.strength_stat_lock_percant_index -= 1
		#_generate_locks()
		
		

func _generate_locks() -> void:
	var max_value: float = IVCellCreator.max_stat_value
	var total_stat_value: float = IVCellCreator.total_stat_value
	var max_width: float = 840.0
	
	var stat_lock_percantages: Array[float] = IVPrisonerProfiler.stat_lock_percantages
	
	if stat_lock_percantages.is_empty():
		push_error("stat_lock_percantages is empty.")
		return
	
	var strength_index: int = IVPrisonerProfiler.strength_stat_lock_percant_index
	var intelligence_index: int = IVPrisonerProfiler.intelligence_stat_lock_percant_index
	var community_index: int = IVPrisonerProfiler.community_stat_lock_percant_index
	
	parent_station.strength_lock_starting_value = _generate_single_lock(
		lock_backgrounds[0],
		strength_index,
		stat_lock_percantages,
		max_value,
		total_stat_value,
		max_width
	)
	
	parent_station.intelligence_lock_starting_value = _generate_single_lock(
		lock_backgrounds[1],
		intelligence_index,
		stat_lock_percantages,
		max_value,
		total_stat_value,
		max_width
	)
	
	parent_station.community_lock_starting_value = _generate_single_lock(
		lock_backgrounds[2],
		community_index,
		stat_lock_percantages,
		max_value,
		total_stat_value,
		max_width
	)
	
	# breifl update the small stat displaty update
	help_lock_small_stat_display.update_small_stat_display_lock()
	

func _generate_single_lock(
	lock_background: ColorRect,
	lock_index: int,
	stat_lock_percantages: Array[float],
	max_value: float,
	total_stat_value: float,
	max_width: float
) -> float:
	
	lock_index = clamp(
		lock_index,
		0,
		stat_lock_percantages.size() - 1
	)
	
	var current_lock_percant: float = stat_lock_percantages[lock_index]
	
	var lock_start_value: float = max_value * current_lock_percant
	
	var lock_percent_of_total: float = clamp(
		lock_start_value / total_stat_value,
		0.0,
		1.0
	)
	
	var inaccessible_percent_of_total: float = clamp(
		max_value / total_stat_value,
		0.0,
		1.0
	)
	
	var lock_x: float = max_width * lock_percent_of_total
	var inaccessible_x: float = max_width * inaccessible_percent_of_total
	
	var lock_width: float = inaccessible_x - lock_x
	lock_width = max(lock_width, 0.0)
	
	lock_background.position.x = lock_x
	lock_background.size.x = lock_width
	
	# this tells it to place lock in middle
	lock_background._place_sprite()
	
	return lock_start_value
