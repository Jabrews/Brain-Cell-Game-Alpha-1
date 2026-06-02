
extends Node2D

## components ##
@onready var comparison_finisher : Node = $ComparisonFinisher

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
###############################
var active_target_cell : BrainCell

func _ready() -> void:
	GLCellManagerBus.connect('target_cell_created', _handle_target_cell_created)
	
## STAT PROPIGATOR TO FINISHER MANAGER ##
func _handle_panel_cell_recieved(panel_cell: BrainCell) :
	comparison_finisher.compare_cells(panel_cell)

## STAT VISUAL ##	
func _handle_target_cell_created(target_cell : BrainCell) :
	
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
	strength_bar.max_value = IVCellCreator.max_stat_value
	intelligence_bar.max_value = IVCellCreator.max_stat_value
	community_bar.max_value = IVCellCreator.max_stat_value
	


func update_bar_value(target_cell : BrainCell) :
	# set progress bars	
	strength_bar.value = target_cell.strength.value
	intelligence_bar.value = target_cell.intelligence.value
	community_bar.value = target_cell.community.value

func update_display_labels(target_brain_cell : BrainCell) :
	for label in large_labels :
		label.text = str(IVCellCreator.max_stat_value)	
		
	# strength
	curr_value_labels[0].text = str(target_brain_cell.strength)
	curr_value_labels[1].text = str(target_brain_cell.intelligence)
	curr_value_labels[2].text = str(target_brain_cell.community)
	
