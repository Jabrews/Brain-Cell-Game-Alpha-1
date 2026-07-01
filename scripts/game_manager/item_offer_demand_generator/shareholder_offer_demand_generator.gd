extends Node


func _ready() -> void:
	GLShareholderOfferState.connect('create_item_offer_demand', _create_demand)
	
	
func _create_demand() :
	
	var demand_cell : BrainCell = generate_demand_cell()	
	var energy_reward : int = 20	
	var energy_left_to_claim : int = 35
	
	var item_offer_constructor = ItemOfferDemandConstructor.new(
		'cell',
		energy_reward,
		energy_left_to_claim,
		demand_cell,
	)	
	
	GLShareholderOfferState.emit_signal('recieve_item_offer_demand', item_offer_constructor )
	

func generate_demand_cell() -> BrainCell:
	var strength_value: float = randi_range(0, IVCellCreator.max_stat_value)
	var intelligence_value: float = randi_range(0, IVCellCreator.max_stat_value)
	var community_value: float = randi_range(0, IVCellCreator.max_stat_value)
	
	const MAX_DISABLED_STATS: int = 1
	
	var stat_types: Array[String] = [
		"strength",
		"intelligence",
		"community"
	]
	
	stat_types.shuffle()
	
	var disabled_amount: int = clamp(MAX_DISABLED_STATS, 0, stat_types.size())
	var disabled_stats: Array[String] = []
	
	for i in range(disabled_amount):
		disabled_stats.append(stat_types[i])
	
	var strength_enabled: bool = not disabled_stats.has("strength")
	var intelligence_enabled: bool = not disabled_stats.has("intelligence")
	var community_enabled: bool = not disabled_stats.has("community")
	
	var strength_stat := BrainCellStat.new(
		"strength",
		strength_enabled,
		strength_value,
		0.0,
		false
	)
	
	var intelligence_stat := BrainCellStat.new(
		"intelligence",
		intelligence_enabled,
		intelligence_value,
		0.0,
		false
	)
	
	var community_stat := BrainCellStat.new(
		"community",
		community_enabled,
		community_value,
		0.0,
		false
	)
	
	var demand_cell := BrainCell.new(
		"demand_cell",
		strength_stat,
		intelligence_stat,
		community_stat,
		false
	)
	
	return demand_cell
