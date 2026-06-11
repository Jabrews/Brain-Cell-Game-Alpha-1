
extends Node

@onready var up_arrows : Array[Sprite2D] = [
	$"../ArrowUp/UpStrength",
	$"../ArrowUp/UpIntelligence",
	$"../ArrowUp/UpCommunity"
]

@onready var down_arrows : Array[Sprite2D] = [
	$"../ArrowDown/DownStrength",
	$"../ArrowDown/DownIntelligence",
	$"../ArrowDown/DownCommunity"
]


func _handle(stat_1 : BrainCellStat, stat_2 : BrainCellStat, stat_index : int) -> void:

	up_arrows[stat_index].visible = false
	down_arrows[stat_index].visible = false

	# disabled stats don't show arrows
	if not stat_1.enabled or not stat_2.enabled:
		return

	var stat_array = GAMECellBreeder.clean_stat_helper.get_highest_lowest_stat(
		stat_1.value,
		stat_2.value
	)

	var stat_high : float = stat_array[0]
	var stat_low : float = stat_array[1]

	var increase_case_min : float = (
		stat_high * IVCellBreeding.clean_stat_increase_case_min
	)

	# same logic as breeding system
	if increase_case_min <= stat_low:
		up_arrows[stat_index].visible = true
		return

	var target_value : float = 0.0

	match stat_1.type:
		"strength":
			target_value = GLCellManagerBus.target_cell_refrence.strength.value

		"intelligence":
			target_value = GLCellManagerBus.target_cell_refrence.intelligence.value

		"community":
			target_value = GLCellManagerBus.target_cell_refrence.community.value

	if GAMECellBreeder.clean_stat_helper.handle_detect_early_stats(
		stat_high,
		stat_low,
		target_value
	):
		up_arrows[stat_index].visible = true
	else:
		down_arrows[stat_index].visible = true
