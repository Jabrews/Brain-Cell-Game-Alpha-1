extends Node

# components
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

func _handle(cell_stats_dic) :
	
	for key in cell_stats_dic.keys():
		var stat : BrainCellStat = cell_stats_dic[key]
		cell_stats_dic = remove_cell_disabled_stat(stat, key, cell_stats_dic)
	
	return cell_stats_dic
	
func remove_cell_disabled_stat(
	stat : BrainCellStat,
	key : String,
	cell_stats_dic : Dictionary
):
	
	if stat.enabled == false :
		match stat.type :
			"strength" :
				progress_bar_sprites[0].modulate.a = 0.1
				progress_bar_sprites[0].material.set_shader_parameter("prisoner_value", 0)
				progress_bar_sprites[0].material.set_shader_parameter("target_value", 0)
				progress_bar_stat_labels[0].modulate.a = 0.1
				curr_value_labels[0].visible = false
				off_disable_labels[0].visible = true
				cell_stats_dic.erase(key)

			"intelligence" :
				progress_bar_sprites[1].modulate.a = 0.1
				progress_bar_sprites[1].material.set_shader_parameter("prisoner_value", 0)
				progress_bar_sprites[1].material.set_shader_parameter("target_value", 0)			
				progress_bar_stat_labels[1].modulate.a = 0.1
				curr_value_labels[1].visible = false 
				off_disable_labels[1].visible = true
				cell_stats_dic.erase(key)

			"community" :
				progress_bar_sprites[2].modulate.a = 0.1
				progress_bar_sprites[2].material.set_shader_parameter("prisoner_value", 0)
				progress_bar_sprites[2].material.set_shader_parameter("target_value", 0)			
				progress_bar_stat_labels[2].modulate.a = 0.1
				curr_value_labels[2].visible = false 
				off_disable_labels[2].visible = true
				cell_stats_dic.erase(key)

	return cell_stats_dic

				
				
				
