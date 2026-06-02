extends Node

@onready var cell_name_label : Label = $"../StatDisplay/CellName"
@onready var cell_lifespan_label : Label = $"../StatDisplay/CellLifeSpan"

@onready var defect_stat_bars : Array[TextureProgressBar] = [
	$"../StatDisplay/DefectBars/DefectStrengthBar",
	$"../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../StatDisplay/DefectBars/DefectCommunityBar"
]

@onready var hide_stat_sprites : Array[Sprite2D] = [
	$"../StatDisplay/HideStats/StrengthHide",
	$"../StatDisplay/HideStats/IntelligenceHide",
	$"../StatDisplay/HideStats/CommunityHide"
]

@onready var curr_stat_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/CurrValueLabels/StrengthCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/IntelligenceCurrLabel",
	$"../StatDisplay/ProgressLabels/CurrValueLabels/CommunityCurrLabel"
]

@onready var max_labels : Array[Label] = [
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Strength/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Intelligence/MaxLabel",
	$"../StatDisplay/ProgressLabels/MinMaxLabels/Community/MaxLabel"
]

@onready var strength_bar : Sprite2D = $"../StatDisplay/ProgressBars/StrengthBar"
@onready var intelligence_bar : Sprite2D = $"../StatDisplay/ProgressBars/IntelligenceBar"
@onready var community_bar : Sprite2D = $"../StatDisplay/ProgressBars/CommunityBar"

var stat_order : Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _display_cell(cell : BrainCell, cell_stats_dic : Dictionary) -> void:
	cell_name_label.text = cell.name
	cell_lifespan_label.text = "lifespan - " + str(cell.life_span)
	
	update_stat_bars(cell_stats_dic)
	update_display_labels(cell_stats_dic)
	update_defect_bar(cell_stats_dic)
	update_hidden_stat(cell_stats_dic)


func update_stat_bars(cell_stats_dic : Dictionary) -> void:
	var max_value : float = IVCellCreator.max_stat_value
	
	var bars : Array[Sprite2D] = [
		strength_bar,
		intelligence_bar,
		community_bar
	]
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	for i in range(stat_order.size()):
		var stat_name : String = stat_order[i]
		var bar : Sprite2D = bars[i]
#		
		var prisoner_value : float = 0.0
		var target_value : float = 0.0
		
		if cell_stats_dic.has(stat_name):
			var stat : BrainCellStat = cell_stats_dic[stat_name]
			prisoner_value = stat.value / max_value
		
			if target_cell != null:
				var target_stat : BrainCellStat = target_cell.get(stat_name)
				if target_stat != null:
					target_value = target_stat.value / max_value
		
		bar.material.set_shader_parameter("prisoner_value", prisoner_value)
		bar.material.set_shader_parameter("target_value", target_value)


func update_display_labels(cell_stats_dic : Dictionary) -> void:
	var max_value : float = IVCellCreator.max_stat_value
	
	for i in range(stat_order.size()):
		var stat_name : String = stat_order[i]
		
		max_labels[i].text = str(max_value)
		
		if cell_stats_dic.has(stat_name):
			var stat : BrainCellStat = cell_stats_dic[stat_name]
			curr_stat_labels[i].text = str(stat.value)
		else:
			curr_stat_labels[i].text = ""


func update_defect_bar(cell_stats_dic : Dictionary) -> void:
	var max_value : float = IVCellCreator.max_stat_value
	
	for i in range(stat_order.size()):
		var stat_name : String = stat_order[i]
		
		defect_stat_bars[i].max_value = max_value
		
		if cell_stats_dic.has(stat_name):
			var stat : BrainCellStat = cell_stats_dic[stat_name]
			defect_stat_bars[i].value = stat.defect
		else:
			defect_stat_bars[i].value = 0


func update_hidden_stat(cell_stats_dic : Dictionary) -> void:
	for i in range(stat_order.size()):
		var stat_name : String = stat_order[i]
		
		if cell_stats_dic.has(stat_name):
			var stat : BrainCellStat = cell_stats_dic[stat_name]
			hide_stat_sprites[i].visible = stat.hidden
		else:
			hide_stat_sprites[i].visible = false
