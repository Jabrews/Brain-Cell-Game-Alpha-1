extends Node

@onready var cell_name_label : Label =$"../StatDisplay/CellName"
@onready var life_span_label : Label =$"../StatDisplay/CellLifeSpan"
@onready var defect_state_bars : Array[TextureProgressBar] = [
	$"../StatDisplay/DefectBars/DefectStrengthBar",
	$"../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../StatDisplay/DefectBars/DefectCommunityBar"
]
@onready var strength_bar  : Sprite2D = $"../StatDisplay/ProgressBars/StrengthBar"
@onready var intelligence_bar  : Sprite2D = $"../StatDisplay/ProgressBars/IntelligenceBar"
@onready var community_bar  : Sprite2D = $"../StatDisplay/ProgressBars/CommunityBar"
@onready var curr_value_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/CurrValueLabels/StrengthCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/IntelligenceCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/CommunityCurrLabel"
]
@onready var max_value_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Strength/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Intelligence/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Community/MaxLabel"
]

func _display_target(target_cell : BrainCell) :
	
	# hide all defect bars	
	for bar : TextureProgressBar in defect_state_bars :
		bar.visible = false
	
	# hide lifespan label
	life_span_label.visible = false
	
	# update cell name
	cell_name_label.text = target_cell.name	
	
	# updae stat vars
	update_bar(target_cell)
	update_curr_label(target_cell)
	

	
func update_bar(target_cell : BrainCell) :	
	var max_val = IVCellCreator.max_stat_value
	
	var target_strength_norm = float(target_cell.strength.value) / max_val
	var target_intelligence_norm = float(target_cell.intelligence.value) / max_val
	var target_community_norm = float(target_cell.community.value) / max_val
	
	# update bars 
	strength_bar.material.set_shader_parameter("target_value", target_strength_norm)
	strength_bar.material.set_shader_parameter("prisoner_value", 0)
	# intelligence
	intelligence_bar.material.set_shader_parameter("target_value", target_intelligence_norm)
	intelligence_bar.material.set_shader_parameter("prisoner_value", 0)
	# community
	community_bar.material.set_shader_parameter("target_value", target_community_norm)
	community_bar.material.set_shader_parameter("prisoner_value", 0)

func update_curr_label(target_cell : BrainCell) :
	curr_value_labels[0].text = str(target_cell.strength.value)
	curr_value_labels[1].text = str(target_cell.intelligence.value)
	curr_value_labels[2].text = str(target_cell.community.value)
	
	
func update_max_label() :
	for max_label : Label in max_value_labels :
		max_label.text = IVCellCreator.max_stat_value
	
	
	
	
