extends Control

@export var popup_type : String


var active_cell : BrainCell
var active_useable_item_obj : UseableItemObject

# componnets 
@onready var strength_stat_option : Control = $Strength
@onready var intelligence_stat_option : Control = $Intelligence
@onready var community_stat_option : Control = $Community
@onready var cell_name : Label = $CellName

# type specific
# defect shot
@onready var defect_shot_node : Control = $DefectShot
@onready var charges_left_label : Label = $DefectShot/ChargestLeft

#


func _ready() -> void:
	GLUsableItemBus.connect('show_useable_item_pop_up', _handle_show_useable_item_pop_up)
	
	if popup_type != 'defect_shot' :
		defect_shot_node.queue_free()
		
		
		
	
func _handle_show_useable_item_pop_up(selected_cell: BrainCell, useable_item_obj : UseableItemObject ) :
	
	# only toggle popup if correct handler type
	if useable_item_obj.item_type != popup_type :
		return
	
	active_cell = selected_cell
	active_useable_item_obj = useable_item_obj
	
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
				
	strength_stat_option.handle_display_stat_info(active_cell.strength)
	intelligence_stat_option.handle_display_stat_info(active_cell.intelligence)
	community_stat_option.handle_display_stat_info(active_cell.community)
	cell_name.text = active_cell.name
	
	if popup_type == 'defect_shot' :	
		charges_left_label.text = str(active_useable_item_obj.item_energy)
				
func _handle_pop_up_stat_selected(stat_type : String) :
	GLUsableItemBus.emit_signal('pop_up_chose_stat', stat_type, active_cell, active_useable_item_obj)
	hide_popup()
	
	
func _handle_hide_useable_item_pop_up(useable_item_obj : UseableItemObject) :
	
	# only toggle popup if correct handler type
	if useable_item_obj.item_type != popup_type	 :
		return
	else :
		hide_popup()

	
func _exit_btn_pressed() :
	hide_popup()

func hide_popup() :
	visible = false 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false 
	
	active_cell = null
	active_useable_item_obj = null
				
	strength_stat_option.handle_display_stat_info(null)
	intelligence_stat_option.handle_display_stat_info(null)
	community_stat_option.handle_display_stat_info(null)
	cell_name.text = 'none'
	
	if popup_type == 'defect_shot' :	
		charges_left_label.text = 'none'
