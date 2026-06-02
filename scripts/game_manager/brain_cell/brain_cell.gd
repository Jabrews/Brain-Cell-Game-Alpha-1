class_name BrainCell

var name : String

var strength : BrainCellStat
var intelligence : BrainCellStat 
var community : BrainCellStat 

var life_span : int

var is_target_cell : bool
var turn_into_flesh_bug : bool
var cell_is_frozen : bool


@warning_ignore("shadowed_variable")
func _init(
	name : String,
	strength : BrainCellStat,
	intelligence : BrainCellStat,
	community : BrainCellStat,
	life_span : int,
	is_target_cell : bool = false,
	turn_into_flesh_bug : bool = false,
	cell_is_frozen : bool = false
):
	self.name = name
	
	self.strength = strength
	self.intelligence = intelligence
	self.community = community
	
	self.life_span = life_span
	self.is_target_cell = is_target_cell
	self.turn_into_flesh_bug = turn_into_flesh_bug
	self.cell_is_frozen = cell_is_frozen


func _print():
	@warning_ignore("incompatible_ternary")
	print(
		"[BrainCell] ",
		name,
		" | STR: ",
		strength.value if strength else "NULL",
		" enabled: ",
		strength.enabled if strength else "NULL",
		" defect: ",
		strength.defect if strength else "NULL",
		" hidden: ",
		strength.hidden if strength else "NULL",
		" | INT: ",
		intelligence.value if intelligence else "NULL",
		" enabled: ",
		intelligence.enabled if intelligence else "NULL",
		" defect: ",
		intelligence.defect if intelligence else "NULL",
		" hidden: ",
		intelligence.hidden if intelligence else "NULL",
		" | COM: ",
		community.value if community else "NULL",
		" enabled: ",
		community.enabled if community else "NULL",
		" defect: ",
		community.defect if community else "NULL",
		" hidden: ",
		community.hidden if community else "NULL",
		" | lifespan: ",
		life_span
	)
	
