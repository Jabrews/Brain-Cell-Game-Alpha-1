extends Control

var selected_cell : BrainCell
var useable_item_obj : UseableItemObject

# componnets 
@onready var strength_stat_option : Control = $Strength
@onready var intelligence_stat_option : Control = $Intelligence
@onready var community_stat_option : Control = $Community
@onready var cell_name : Label = $CellName


func _ready() -> void:
	GLUsableItemBus.connect('toggle_show_scissors_pop_up', _handle_toggle_show_scissors_pop_up)

func _handle_toggle_show_scissors_pop_up(toggle_value : bool, new_selected_cell : BrainCell, new_useable_item_obj : UseableItemObject ) :
		match toggle_value :	
			true : 
				
				selected_cell = new_selected_cell
				useable_item_obj = new_useable_item_obj
				
				visible = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				get_tree().paused = true
				
				strength_stat_option.handle_display_stat_info(selected_cell.strength)
				intelligence_stat_option.handle_display_stat_info(selected_cell.intelligence)
				community_stat_option.handle_display_stat_info(selected_cell.community)
				
				cell_name.text = new_selected_cell.name
				
				
				
			false : 
				
				selected_cell = null 
				useable_item_obj = null
				
				visible = false 
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().paused = false 
				
				strength_stat_option.handle_display_stat_info(null)
				intelligence_stat_option.handle_display_stat_info(null)
				community_stat_option.handle_display_stat_info(null)
				
				cell_name.text = 'none'
