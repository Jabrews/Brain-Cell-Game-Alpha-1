extends Node

# componnets
@onready var pick_num_left_label : Label = $PickNum


func _ready() -> void:
	
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked)
	GLCellCreatorBus.connect('get_newest_prisoner_cells', _handle_new_batch)
	GLCellManagerBus.connect('delete_remaining_prisoners', _handle_delete_remaining_prisoners)
	
	update_pick_display()


func _handle_prisoner_picked(_prisoner) :
	update_pick_display(1)


func _handle_new_batch(_new_cells: Array[BrainCell]) :
	update_pick_display()


func _handle_delete_remaining_prisoners() :
	pick_num_left_label.text = '0'


func update_pick_display(extra_picks : int = 0) :
	
	var max_prisoner_pick = IVPrisonerSpawner.max_picked_pris_per_turn
	var curr_prisoners_picked = IVPrisonerSpawner.curr_picked_pris_per_turn + extra_picks
	
	var picks_left = max_prisoner_pick - curr_prisoners_picked
	
	pick_num_left_label.text = str(picks_left)
