extends Node

# componnets
@onready var help_shake_symbols : Node = $HelpShakeSymbols
@onready var bar : Sprite2D = $Bar
@onready var off_display : Control = $OffDisplay
@onready var not_enough_power_display : Control = $NotEnoughPower
@onready var parent_stat_control_panel : Node3D = $"../../../.."

func _ready() -> void:
	bar.material = bar.material.duplicate()
	
	# update target stat on startup
	GLCellManagerBus.connect('target_cell_created', _handle_get_newest_target_cell)	
	#GLPrisonerProfilerComponentsBus.connect('player_tried_creating_with_invalid_energy', _handle_player_tried_creating_with_invalid_energy)
	
func _toggle_display_off_screen(toggleValue : bool) :
	if toggleValue :
		off_display.visible = true
	else : 
		off_display.visible = false

func update_target_stat(target_stat_value : float) :
	
	var max_val = IVCellCreator.max_stat_value

	# prisoner (yellow)
	var target_stat_norm = float(target_stat_value) / max_val
	
	bar.material.set_shader_parameter("target_value", target_stat_norm)
	

func update_current_stat_value(current_stat_value : float, current_clean_range : String) :
	var max_val = IVCellCreator.max_stat_value

	# prisoner (yellow)
	var stat_norm = float(current_stat_value) / max_val
	
	help_shake_symbols.	_handle_update_shake_symbols(current_clean_range)
	
	bar.material.set_shader_parameter("prisoner_value", stat_norm)

func _handle_get_newest_target_cell(target_cell : BrainCell) :
	
	match parent_stat_control_panel.stat_type  :
		'strength' :	
			update_target_stat(target_cell.strength.value)
		'intelligence' :
			update_target_stat(target_cell.intelligence.value)
		'community' :
			update_target_stat(target_cell.community.value)

func _handle_reset() :
	bar.material.set_shader_parameter("prisoner_value", 0)
	update_current_stat_value(0, 'none')
		
func _handle_player_tried_creating_with_invalid_energy() :
	not_enough_power_display.visible = true
	
	await get_tree().create_timer(2.0).timeout
	
	not_enough_power_display.visible = false
	
	
