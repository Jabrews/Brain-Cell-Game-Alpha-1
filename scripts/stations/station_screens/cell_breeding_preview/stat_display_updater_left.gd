extends Node

## components

@onready var stat_display : Control = $"../WaitingScreen/CellLeftLoader/StatDisplay"

@onready var prisoner_name_label : Label = $"../WaitingScreen/CellLeftLoader/StatDisplay/PrisonerName"

# sprite stat bars
@onready var clean_strength_bar : Sprite2D = $"../WaitingScreen/CellLeftLoader/StatDisplay/StatDisplay/StrengthBar"
@onready var clean_intelligence_bar : Sprite2D = $"../WaitingScreen/CellLeftLoader/StatDisplay/StatDisplay/IntelligenceBar"
@onready var clean_community_bar : Sprite2D = $"../WaitingScreen/CellLeftLoader/StatDisplay/StatDisplay/CommunityBar"

@onready var defect_state_bars : Array[TextureProgressBar] = [
	$"../WaitingScreen/CellLeftLoader/StatDisplay/DefectBars/DefectStrengthBar",
	$"../WaitingScreen/CellLeftLoader/StatDisplay/DefectBars/DefectIntelligenceBar",
 	$"../WaitingScreen/CellLeftLoader/StatDisplay/DefectBars/DefectCommunityBar",
]

# bar current value labels 
@onready var clean_curr_value_labels : Array[Label] = [
	$"../WaitingScreen/CellLeftLoader/StatDisplay/BarLabels/Strength/StrengthCurrLabel",
	$"../WaitingScreen/CellLeftLoader/StatDisplay/BarLabels/Intelligence/IntelligenceCurrLabel",
	$"../WaitingScreen/CellLeftLoader/StatDisplay/BarLabels/Community/CommunityCurrLabel",
]

# hidden stats
@onready var hidden_stat_blockers : Array[Sprite2D] = [
	$"../WaitingScreen/CellLeftLoader/StatDisplay/HideStats/StrengthHide",
	$"../WaitingScreen/CellLeftLoader/StatDisplay/HideStats/IntelligenceHide",
	$"../WaitingScreen/CellLeftLoader/StatDisplay/HideStats/CommunityHide"
]

func _ready() -> void:
	stat_display.visible = false	
	
	clean_strength_bar.material = clean_strength_bar.material.duplicate()
	clean_intelligence_bar.material = clean_intelligence_bar.material.duplicate()
	clean_community_bar.material = clean_community_bar.material.duplicate()

# main entry point for updating 
func _load_breeding_panel_cell(designated_brain_cell: BrainCell) :
	
	# when panel cell is null (not on panel)
	if not designated_brain_cell :
		stat_display.visible = false
		return
		
	stat_display.visible = true
	prisoner_name_label.text = designated_brain_cell.name
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	update_bar_value(designated_brain_cell, target_cell)
	update_display_labels(designated_brain_cell)
	update_defect_bar(designated_brain_cell)
	handle_hidden_stats(designated_brain_cell)
	


func update_bar_value(prisoner_cell : BrainCell, target_cell : BrainCell):

	var max_val = IVCellCreator.max_stat_value

	# prisoner (yellow)
	var strength_norm = float(prisoner_cell.strength.value) / max_val
	var intelligence_norm = float(prisoner_cell.intelligence.value) / max_val
	var community_norm = float(prisoner_cell.community.value) / max_val

	# target (red)
	var target_strength_norm = 0.0
	var target_intelligence_norm = 0.0
	var target_community_norm = 0.0

	if target_cell:
		target_strength_norm = float(target_cell.strength.value) / max_val
		target_intelligence_norm = float(target_cell.intelligence.value) / max_val
		target_community_norm = float(target_cell.community.value) / max_val

	# strength
	clean_strength_bar.material.set_shader_parameter("prisoner_value", strength_norm)
	clean_strength_bar.material.set_shader_parameter("target_value", target_strength_norm)

	# intelligence
	clean_intelligence_bar.material.set_shader_parameter("prisoner_value", intelligence_norm)
	clean_intelligence_bar.material.set_shader_parameter("target_value", target_intelligence_norm)

	# community
	clean_community_bar.material.set_shader_parameter("prisoner_value", community_norm)
	clean_community_bar.material.set_shader_parameter("target_value", target_community_norm)

func update_display_labels(prisoner_cell: BrainCell):
		
	clean_curr_value_labels[0].text = str(prisoner_cell.strength)
	clean_curr_value_labels[1].text = str(prisoner_cell.intelligence)
	clean_curr_value_labels[2].text = str(prisoner_cell.community)

func update_defect_bar(prisoner_cell: BrainCell):
	
	#var max_value = GlIncrementalValues.target_range_max
	var max_value = IVCellCreator.max_stat_value
	
	for bar in defect_state_bars:
		bar.max_value = max_value
	
	defect_state_bars[0].value = prisoner_cell.strength_defect
	defect_state_bars[1].value = prisoner_cell.intelligence_defect
	defect_state_bars[2].value = prisoner_cell.community_defect

func handle_hidden_stats(prisoner_cell : BrainCell) :
	
	hidden_stat_blockers[0].visible = prisoner_cell.strength_hidden
	hidden_stat_blockers[1].visible = prisoner_cell.intelligence_hidden
	hidden_stat_blockers[2].visible = prisoner_cell.community_hidden


	

	
