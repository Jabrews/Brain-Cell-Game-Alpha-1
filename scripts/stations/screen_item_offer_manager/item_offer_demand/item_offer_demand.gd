extends Node

# componnets
@onready var switch_screen : Node = $SwitchScreen
@onready var parent_station : Node3D = $"../../../.."

# demand display
@onready var stat_demand : Control = $Demand/StatDemand

# evluation helpers
@onready var cell_evaluation : Node = $Evaluations/CellEvaluation



func _load_demand(demand_type : String) :
	match demand_type : 
		'cell' :
			var demand_cell : BrainCell = parent_station.selected_offer_demand_constructor.demand_cell
			stat_demand._load_cell(demand_cell)

func _handle_cell_recieved(demand : ItemOfferDemandConstructor , brain_cell : BrainCell) :
	
	var compare_sucess : bool 
	
	match demand.demand_type:
		'cell' :
			compare_sucess = cell_evaluation._evaluate(brain_cell, demand.demand_cell)		
	
	return compare_sucess
		
						




			
			
			
	
	
	
	
