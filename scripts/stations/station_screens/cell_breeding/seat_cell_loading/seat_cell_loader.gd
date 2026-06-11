extends Node

var active_cell : BrainCell

## componnets
# labels
@onready var no_cell_loaded_label : Label = $NoCellLoaded
@onready var cell_name_label : Label  = $LoadedCellDisplay/CellName
# loaded cell display 
@onready var loaded_cell_display : Control = $LoadedCellDisplay
@onready var hide_stats_parent : Control = $LoadedCellDisplay/HideStats
@onready var off_disable_parent : Control = $LoadedCellDisplay/OffDisableLabels
@onready var progress_bars_parent : Control = $LoadedCellDisplay/ProgressBars
@onready var defect_bars_parent : Control = $LoadedCellDisplay/DefectBars
# main visual interpreter logic
@onready var display_cell : Node = $DisplayCell


func _load(brain_cell : BrainCell) :
	
	active_cell = brain_cell
	
	if not active_cell:
		toggle_cell_display(false)
		reset_display()
	
	if active_cell :
		toggle_cell_display(true)
		reset_display()
		display_cell._display(active_cell)
		
		

func toggle_cell_display(toggle_value : bool) :
	loaded_cell_display.visible = toggle_value
	no_cell_loaded_label.visible = !toggle_value

	
func reset_display() :
	
	cell_name_label.text = 'NONE'
	
	for hide_sprite : Sprite2D in hide_stats_parent.get_children():
		hide_sprite.visible = false
	
	for off_display_label : Label in off_disable_parent.get_children() :
		off_display_label.visible = false
	
	for defect_bar : TextureProgressBar in defect_bars_parent.get_children() :
		defect_bar.visible = true
	
	for progress_bar_child in progress_bars_parent.get_children() :
		progress_bar_child.visible = true
	
	# reset value
	for node in progress_bars_parent.get_children():
		if node is Sprite2D:
			node.material.set_shader_parameter("prisoner_value", 0.0)
			node.material.set_shader_parameter("target_value", 0.0)
		
		if node is Label :
			node.modulate.a = 1.0
	
	for defect_bar : TextureProgressBar in defect_bars_parent.get_children() :
		defect_bar.value = 0
	
	
	
	
	
	
		
	
	
	
	
	
