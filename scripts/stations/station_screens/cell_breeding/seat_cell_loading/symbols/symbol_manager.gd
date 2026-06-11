extends Node

@onready var handle_checkmarks : Node = $HandleCheckmarks
@onready var handle_hidden : Node = $HandleHidden
@onready var handle_arrow : Node = $HandleArrow


func check_for_checkmarks(side : String, brain_cell : BrainCell) -> void:
	handle_checkmarks._handle(side, brain_cell)

func check_for_symbols(cell_1 : BrainCell, cell_2 : BrainCell) -> void:

	var stats_1 = [
		cell_1.strength,
		cell_1.intelligence,
		cell_1.community
	]

	var stats_2 = [
		cell_2.strength,
		cell_2.intelligence,
		cell_2.community
	]

	for i in range(3):
		var has_hidden_stat = handle_hidden._handle(
			stats_1[i],
			stats_2[i]
		)

		if not has_hidden_stat:
			handle_arrow._handle(
				stats_1[i],
				stats_2[i],
				i
			)
	
	
	
	

func hide_symbols() -> void:
	for parent_child : Node in get_children():

		# don't hide checkmarks
		if parent_child.name == "LeftCheckmarks" or parent_child.name == "RightCheckmarks":
			continue

		for child : Node in parent_child.get_children():
			if child is CanvasItem:
				child.visible = false
