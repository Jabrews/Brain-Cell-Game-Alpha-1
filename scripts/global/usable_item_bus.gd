extends Node

signal spawn_new_usable_items()

# all useable items
signal useable_item_picked_up(useable_item_obj : UseableItemObject)
signal useable_item_dropped(useable_item_obj : UseableItemObject)
signal useable_item_used(item_used_up, new_useable_item) #item used up refers to if theres energy left

# indv items	
signal use_defect_shot(selected_cell : BrainCell, useable_item_obj : UseableItemObject)
signal use_hidden_shot(selected_cell : BrainCell, useable_item_obj : UseableItemObject)
signal use_steroid(selected_cell : BrainCell, useable_item_obj : UseableItemObject)
signal use_ice_cube(selected_cell : BrainCell, useable_item_obj : UseableItemObject)
# scissors
signal toggle_show_scissors_pop_up(toggle_value : bool, selected_cell : BrainCell, useable_item_obj : UseableItemObject)
signal scissor_pop_up_chose_stat(selected_stat : String, selected_cell : BrainCell, useable_item_obj : UseableItemObject )

signal use_scissors(selected_cell : BrainCell, useable_item_obj : UseableItemObject, selected_stat : String)
