extends Node

## CHECK MARKS ##
@export var checkmark_range : float = 30.0
@onready var left_checkmarks : Array[Sprite2D] = [
	$"../LeftCheckmarks/Strength", $"../LeftCheckmarks/Intelligence", $"../LeftCheckmarks/Community"
]
@onready var right_checkmarks : Array[Sprite2D] = [
	$"../RightCheckmarks/Strength", $"../RightCheckmarks/Intelligence", $"../RightCheckmarks/Community"
]
#################

func _handle(side : String, brain_cell : BrainCell) -> void:
	var checkmarks : Array[Sprite2D]

	match side:
		"left":
			checkmarks = left_checkmarks
		"right":
			checkmarks = right_checkmarks
		_:
			push_error("Invalid checkmark side: " + side)
			return

	for checkmark : Sprite2D in checkmarks:
		checkmark.visible = false

	if not brain_cell:
		return

	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence

	if not target_cell:
		return

	checkmarks[0].visible = (
		not brain_cell.strength.hidden
		and _is_within_range(brain_cell.strength.value, target_cell.strength.value)
	)

	checkmarks[1].visible = (
		not brain_cell.intelligence.hidden
		and _is_within_range(brain_cell.intelligence.value, target_cell.intelligence.value)
	)

	checkmarks[2].visible = (
		not brain_cell.community.hidden
		and _is_within_range(brain_cell.community.value, target_cell.community.value)
	)


func _is_within_range(value : float, target_value : float) -> bool:
	return abs(value - target_value) <= checkmark_range
