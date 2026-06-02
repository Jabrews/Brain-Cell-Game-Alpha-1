extends Node


@onready var cell_life_span_label : Label = $"../StatDisplay/CellLifeSpan"
@onready var cell_name_label : Label = $"../StatDisplay/CellName"

@onready var progress_bar_sprites : Array[Sprite2D]= [
	$"../StatDisplay/ProgressBars/StrengthBar",
	$"../StatDisplay/ProgressBars/IntelligenceBar",
	$"../StatDisplay/ProgressBars/CommunityBar"
]
@onready var progress_bar_stat_labels : Array[Label] = [
	$"../StatDisplay/ProgressBars/StengthLabel",
	$"../StatDisplay/ProgressBars/IntelligenceLabel",
	$"../StatDisplay/ProgressBars/CommunityLabel"
]
@onready var curr_value_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/CurrValueLabels/StrengthCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/IntelligenceCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/CommunityCurrLabel"
]
@onready var off_disable_labels : Array[Label] = [
	$"../StatDisplay/OffDisableLabels/StrengthOffLabel",
	$"../StatDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../StatDisplay/OffDisableLabels/CommunityOffLabel"
]
@onready var defect_bars : Array[TextureProgressBar] = [
	$"../StatDisplay/DefectBars/DefectStrengthBar",
	$"../StatDisplay/DefectBars/DefectIntelligenceBar", 
	$"../StatDisplay/DefectBars/DefectCommunityBar"
]
@onready var hide_stat_sprites : Array[Sprite2D] = [
	$"../StatDisplay/HideStats/StrengthHide",
 	$"../StatDisplay/HideStats/IntelligenceHide",
 	$"../StatDisplay/HideStats/CommunityHide"	
]
@onready var max_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Strength/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Intelligence/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Community/MaxLabel"
	
]

func _reset(disable_progress_labels : bool) :
	
	## RESET NAME AND LIFESPAN ##	
	cell_life_span_label.visible = true
	cell_life_span_label.text = '0'
	cell_name_label.text = ''
	#############################
	
	 ## RESET MAX AND CURR LABLES ##
	for max_label in max_labels :
		max_label.text = str(IVCellCreator.max_stat_value)
	for curr_label in curr_value_labels :
		curr_label.text = '0'

	################################
	
	
	## RESET BARS ##	
	for bar : TextureProgressBar in defect_bars :
		bar.value = 0
	for bar : Sprite2D in progress_bar_sprites :
		bar.material.set_shader_parameter("prisoner_value", 0)
		bar.material.set_shader_parameter("target_value", 0)
	#################
	
	
	## SPECIFIC HELPER RESETS ##	
	# reset disable stuff
	for sprite : Sprite2D in progress_bar_sprites :
		sprite.modulate.a = 1.0
	for label : Label in progress_bar_stat_labels :
		label.modulate.a = 1.0
	for label : Label in off_disable_labels :
		label.visible = false
	if not disable_progress_labels :			
		for label : Label in curr_value_labels :
			label.visible = true
		
	# reset target stuff
	for bar : TextureProgressBar in defect_bars :
		bar.visible = true
	
	# reset cell stuff
	for hide_sprite : Sprite2D in hide_stat_sprites :
		hide_sprite.visible = false
	#############################
	
