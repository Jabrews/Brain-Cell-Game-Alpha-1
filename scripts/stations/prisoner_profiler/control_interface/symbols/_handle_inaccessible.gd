extends Node

@onready var parent_station : Node3D = $"../../.."
@onready var inaccessible_backgrounds : Array[ColorRect] = [
	$"../../../StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Inaccessible/InaccessibleBG",
	$"../../../StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Inaccessible/InaccessibleBG",
	$"../../../StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/Inaccessible/InaccessibleBG",
	$"../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/Inaccessible/InaccessibleBG",
]


func _generate_inaccessible() -> void:
	var starting_inac_value: float = IVCellCreator.max_stat_value
	var total_stat_value: float = IVCellCreator.total_stat_value
	
	parent_station.inaccessible_starting_value = starting_inac_value
	
	var max_width: float = 840.0
	
	# Example: 200 / 400 = 0.5
	var percent: float = clamp(
		starting_inac_value / total_stat_value,
		0.0,
		1.0
	)
	
	# Example: 840 * 0.5 = 420
	var limit_x: float = max_width * percent
	
	# Inaccessible starts at the limit and continues to the right
	var inaccessible_x: float = limit_x
	var inaccessible_width: float = max_width - limit_x
	
	for inaccessible_background: ColorRect in inaccessible_backgrounds:
		inaccessible_background.position.x = inaccessible_x
		inaccessible_background.size.x = inaccessible_width
