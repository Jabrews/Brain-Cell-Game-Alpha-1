
extends Node2D

## compare screen componnets ##
# name label
@onready var target_name_label : Label = $TargetStatDisplay/TargetName
# bar
@onready var strength_bar : TextureProgressBar = $TargetStatDisplay/ProgressBars/Strength/StrengthBar
@onready var intelligence_bar : TextureProgressBar = $TargetStatDisplay/ProgressBars/Intelligence/IntelligenceBar
@onready var community_bar : TextureProgressBar = $TargetStatDisplay/ProgressBars/Community/CommunityBar
# bar max label 
@onready var large_labels : Array[Label] = [
	$TargetStatDisplay/ProgressLabels/Strength/LargeLabel,
	$TargetStatDisplay/ProgressLabels/Intelligence/LargeLabel2,
	$TargetStatDisplay/ProgressLabels/Community/LargeLabel3
]
# bar value labels 
@onready var curr_value_labels : Array[Label] = [
	$TargetStatDisplay/ProgressBars/Strength/StrengthCurrLabel,	
	$TargetStatDisplay/ProgressBars/Intelligence/IntelligenceCurrLabel,
	$TargetStatDisplay/ProgressBars/Community/CommunityCurrLabel,
]

@onready var active_stat_indicators : Array[ColorRect] = [
	$TargetStatDisplay/ActiveStatIndicator/StrengthActive,
	$TargetStatDisplay/ActiveStatIndicator/IntelligenceActive,
	$TargetStatDisplay/ActiveStatIndicator/CommunityActive
]

###############################

var active_target_cell : BrainCell

func _update_active_stat_indicator(current_active_stat_indicator_index : int) -> void:
	
	for i in range(active_stat_indicators.size()):

		var active_stat_indicator = active_stat_indicators[i]

		# array index starts at 0
		var current_index = i

		# turn visible else turn off
		active_stat_indicator.visible = (
			current_index == current_active_stat_indicator_index
		)


## STAT VISUAL ##	
func _update_custom_cell_screen(target_cell : BrainCell) :
	
	if not target_cell :
		push_error('target_cell_compare_screen : target cell created with invalid cell')
	
	# set name
	target_name_label.text = 'target - ' + target_cell.name
	
	update_display_labels(target_cell)
	update_bar_max()
	update_bar_value(target_cell)
	
	active_target_cell = target_cell

func update_bar_max() :
	# update progress bars max vs min
	strength_bar.max_value = IVCellCreator.target_stat_max
	intelligence_bar.max_value = IVCellCreator.target_stat_max
	community_bar.max_value = IVCellCreator.target_stat_max
	


func update_bar_value(target_cell : BrainCell) :
	# set progress bars	
	strength_bar.value = target_cell.strength
	intelligence_bar.value = target_cell.intelligence
	community_bar.value = target_cell.community

func update_display_labels(target_brain_cell : BrainCell) :
	for label in large_labels :
		label.text = str(IVCellCreator.target_stat_max)	
		
	# strength
	curr_value_labels[0].text = str(target_brain_cell.strength)
	curr_value_labels[1].text = str(target_brain_cell.intelligence)
	curr_value_labels[2].text = str(target_brain_cell.community)
	
