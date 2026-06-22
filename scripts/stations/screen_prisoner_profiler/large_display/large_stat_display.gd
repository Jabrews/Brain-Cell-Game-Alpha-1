extends Node2D 

# componets
@onready var bar : Sprite2D = $Bar
@onready var handle_switch_screen : Node = $LargeHandleSwitchScreen

@export var selected_stat_type : String
var selected_stat_value : float = 0
var selected_stat_enabled : bool = true


func _ready() -> void:
	bar.material = bar.material.duplicate()
	
	await get_tree().process_frame
	
	update_bar()

func _update_stat(stat_value : float, stat_enabled : bool) :
	
	selected_stat_value = stat_value
	selected_stat_enabled = stat_enabled
	
	if selected_stat_enabled :
		handle_switch_screen._switch('on')
	else :
		handle_switch_screen._switch('off')
	
	update_bar()

func update_bar() :
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	if target_cell :
		
		var target_value = target_cell.get_stat(selected_stat_type).value
		var prisoner_value = selected_stat_value	
		var total_max_value = IVCellCreator.total_stat_value
		
		target_value = target_value / total_max_value
		prisoner_value = prisoner_value / total_max_value
		
		bar.material.set_shader_parameter('target_value', target_value)
		bar.material.set_shader_parameter('prisoner_value', prisoner_value)



		
		
