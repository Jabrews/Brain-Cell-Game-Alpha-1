extends Node

var target_cell_refrence : BrainCell 
var prisoner_cells_refrence : Array[BrainCell]
var collected_cells_refrence : Array[BrainCell]

# connected
signal prisoner_picked_by_player(prisoner_cell : BrainCell)
signal delete_remaining_prisoners() # called by pris. spawner
signal cell_breeded(old_cell_1 : BrainCell, old_cell_2 : BrainCell, new_collected_cell : BrainCell)
signal delete_selected_collected_cell(collected_cell: BrainCell)
signal hidden_stat_interpreted(selected_cell : BrainCell, selected_stat : String)
signal interpreter_jolt_increase_cell_defect(selected_cell : BrainCell, selected_stat : String)
signal cell_container_jolt_increase_cell_defect(selected_cell : BrainCell)
signal delete_cells_for_next_round()

# emmited
signal cell_deleted(cell_name : String)
signal cell_changed(new_cell : BrainCell)
signal cell_added_to_collection(new_collected_cell : BrainCell)
signal cells_updated()
signal target_cell_created(target_cell : BrainCell)

### DEBUG ###
signal debug_collected_cells_and_target_create(collected_cells : Array[BrainCell], target_cell : BrainCell)
