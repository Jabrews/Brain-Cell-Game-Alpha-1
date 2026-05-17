extends Node

## components

@onready var stat_display = $StatDisplay

@onready var prisoner_name_label : Label = $StatDisplay/PrisonerName
@onready var life_span_label : Label = $StatDisplay/PrisonerLifeSpan
@onready var prisoner_stats_parent : Control = $StatDisplay/ProgressBars

# sprite stat bars
@onready var clean_strength_bar : Sprite2D = $StatDisplay/ProgressBars/CleanTargetBars/StrengthBar
@onready var clean_intelligence_bar : Sprite2D = $StatDisplay/ProgressBars/CleanTargetBars/IntelligenceBar
@onready var clean_community_bar : Sprite2D = $StatDisplay/ProgressBars/CleanTargetBars/CommunityBar

@onready var defect_state_bars : Array[TextureProgressBar] = [
	$StatDisplay/ProgressBars/DefectBars/DefectStrengthBar,
	$StatDisplay/ProgressBars/DefectBars/DefectIntelligenceBar,
	$StatDisplay/ProgressBars/DefectBars/DefectCommunityBar,
]

# bar max labels 
@onready var large_labels : Array[Label] = [
	$StatDisplay/ProgressBars/ProgressLabels/Strength/LargeLabel,
	$StatDisplay/ProgressBars/ProgressLabels/Intelligence/LargeLabel2,
	$StatDisplay/ProgressBars/ProgressLabels/Community/LargeLabel3
]

# bar current value labels 
@onready var clean_curr_value_labels : Array[Label] = [
	$StatDisplay/ProgressBars/BarLabels/Strength/StrengthCurrLabel,
	$StatDisplay/ProgressBars/BarLabels/Intelligence/IntelligenceCurrLabel,
	$StatDisplay/ProgressBars/BarLabels/Community/CommunityCurrLabel,
]

@onready var active_stat_indicators : Array[ColorRect] = [
	$StatDisplay/ActiveStatIndicator/StrengthActive,
	$StatDisplay/ActiveStatIndicator/StrengthDefActive,
	$StatDisplay/ActiveStatIndicator/IntelligenceActive,
	$StatDisplay/ActiveStatIndicator/IntelligenceDefActive,
	$StatDisplay/ActiveStatIndicator/CommunityActive,
	$StatDisplay/ActiveStatIndicator/CommunityDefActive
]

func _ready() -> void:
	
	stat_display.visible = false	
	
	clean_strength_bar.material = clean_strength_bar.material.duplicate()
	clean_intelligence_bar.material = clean_intelligence_bar.material.duplicate()
	clean_community_bar.material = clean_community_bar.material.duplicate()

func _update_active_stat_indicator(current_active_stat_indicator_index : int) -> void:
	
	for i in range(active_stat_indicators.size()):

		var active_stat_indicator = active_stat_indicators[i]

		# array index starts at 0
		var current_index = i

		# turn visible else turn off
		active_stat_indicator.visible = (
			current_index == current_active_stat_indicator_index
		)


# main entry point for updating 
func _update_custom_cell_screen(designated_brain_cell : BrainCell) : 
	
		
	stat_display.visible = true
	prisoner_name_label.text = designated_brain_cell.name
	life_span_label.text = 'lifespan - ' + str(designated_brain_cell.life_span)
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	update_bar_value(designated_brain_cell, target_cell)
	update_display_labels(designated_brain_cell)
	update_defect_bar(designated_brain_cell)
	


func update_bar_value(prisoner_cell : BrainCell, target_cell : BrainCell):

	var max_val = IVCellCreator.target_stat_max

	# prisoner (yellow)
	var strength_norm = float(prisoner_cell.strength) / max_val
	var intelligence_norm = float(prisoner_cell.intelligence) / max_val
	var community_norm = float(prisoner_cell.community) / max_val

	# target (red)
	var target_strength_norm = 0.0
	var target_intelligence_norm = 0.0
	var target_community_norm = 0.0

	if target_cell:
		target_strength_norm = float(target_cell.strength) / max_val
		target_intelligence_norm = float(target_cell.intelligence) / max_val
		target_community_norm = float(target_cell.community) / max_val

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
	for label in large_labels:
		
		var max_value = IVCellCreator.target_stat_max
		#label.text = str(GlIncrementalValues.target_range_max)	
		label.text = str(max_value)
		
	clean_curr_value_labels[0].text = str(prisoner_cell.strength)
	clean_curr_value_labels[1].text = str(prisoner_cell.intelligence)
	clean_curr_value_labels[2].text = str(prisoner_cell.community)

func update_defect_bar(prisoner_cell: BrainCell):
	
	#var max_value = GlIncrementalValues.target_range_max
	var max_value = IVCellCreator.target_stat_max
	
	for bar in defect_state_bars:
		bar.max_value = max_value
	
	defect_state_bars[0].value = prisoner_cell.strength_defect
	defect_state_bars[1].value = prisoner_cell.intelligence_defect
	defect_state_bars[2].value = prisoner_cell.community_defect


	

	
