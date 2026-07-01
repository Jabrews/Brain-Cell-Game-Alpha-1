extends Node

@onready var clean_bar_sprites: Array[Sprite2D] = [
	$CleanBars/Bars/StrengthBar,
	$CleanBars/Bars/IntelligenceBar,
	$CleanBars/Bars/CommunityBar
]

@onready var current_value_labels: Array[Label] = [
	$CleanBars/ValueLabel/StrengthCurrLabel,
	$CleanBars/ValueLabel/IntelligenceCurrLabel,
	$CleanBars/ValueLabel/CommunityCurrLabel
]

@onready var no_stat_required_parents: Array[Control] = [
	$NoStatRequired/Strength,
	$NoStatRequired/Intelligence,
	$NoStatRequired/Community
]


func _ready() -> void:
	for bar: Sprite2D in clean_bar_sprites:
		bar.material = bar.material.duplicate()


func _load_cell(demand_cell: BrainCell) -> void:
	reset_screen()
	
	load_clean_bars(demand_cell)
	load_curr_value_labels(demand_cell)
	load_disabled_stat(demand_cell)


func load_clean_bars(demand_cell: BrainCell) -> void:
	var max_stat_value: float = IVCellCreator.max_stat_value
	
	var strength_value: float = demand_cell.strength.value / max_stat_value
	var intelligence_value: float = demand_cell.intelligence.value / max_stat_value
	var community_value: float = demand_cell.community.value / max_stat_value
	
	clean_bar_sprites[0].material.set_shader_parameter("prisoner_value", strength_value)
	clean_bar_sprites[1].material.set_shader_parameter("prisoner_value", intelligence_value)
	clean_bar_sprites[2].material.set_shader_parameter("prisoner_value", community_value)


func load_curr_value_labels(demand_cell: BrainCell) -> void:
	current_value_labels[0].text = str(demand_cell.strength.value)
	current_value_labels[1].text = str(demand_cell.intelligence.value)
	current_value_labels[2].text = str(demand_cell.community.value)


func load_disabled_stat(demand_cell: BrainCell) -> void:
	var stats: Array[BrainCellStat] = [
		demand_cell.strength,
		demand_cell.intelligence,
		demand_cell.community
	]
	
	for i in stats.size():
		var stat: BrainCellStat = stats[i]
		
		if stat.enabled:
			clean_bar_sprites[i].visible = true
			current_value_labels[i].visible = true
			no_stat_required_parents[i].visible = false
		else:
			clean_bar_sprites[i].visible = false
			current_value_labels[i].visible = false
			no_stat_required_parents[i].visible = true


func reset_screen() -> void:
	for i in clean_bar_sprites.size():
		clean_bar_sprites[i].visible = true
		current_value_labels[i].visible = true
		no_stat_required_parents[i].visible = false
		
		current_value_labels[i].text = "0"
		clean_bar_sprites[i].material.set_shader_parameter("prisoner_value", 0.0)
