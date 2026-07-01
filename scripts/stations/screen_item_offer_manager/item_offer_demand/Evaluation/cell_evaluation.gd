extends Node


func _evaluate(brain_cell: BrainCell, demand_cell: BrainCell) -> bool:
	var allowed_range: float = 20.0
	
	var strength_valid: bool = evaluate_stat(
		brain_cell.strength,
		demand_cell.strength,
		allowed_range
	)
	
	var intelligence_valid: bool = evaluate_stat(
		brain_cell.intelligence,
		demand_cell.intelligence,
		allowed_range
	)
	
	var community_valid: bool = evaluate_stat(
		brain_cell.community,
		demand_cell.community,
		allowed_range
	)
	
	return strength_valid and intelligence_valid and community_valid


func evaluate_stat(
	brain_cell_stat: BrainCellStat,
	demand_cell_stat: BrainCellStat,
	allowed_range: float
) -> bool:
	# If demand does not require this stat, ignore it.
	if not demand_cell_stat.enabled:
		return true
	
	# If demand requires the stat, but the player's cell does not have it, fail.
	if not brain_cell_stat.enabled:
		return false
	
	var difference: float = abs(brain_cell_stat.value - demand_cell_stat.value)
	
	if difference <= allowed_range:
		return true
	
	return false
