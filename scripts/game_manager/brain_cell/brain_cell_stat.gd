extends Node

class_name BrainCellStat

var type : String
var enabled : bool
var value : float
var defect : float
var hidden : bool

@warning_ignore("shadowed_variable")
func _init(
	type : String,
	enabled : bool,
	value : float,
	defect : float,
	hidden : bool,
):
	self.type = type
	self.enabled = enabled
	self.value = value
	self.defect = defect
	self.hidden = hidden


func _print():
	print(
		"[Stat] ",
		type,
		" | enabled: ",
		enabled,
		" | value: ",
		value,
		" | defect: ",
		defect,
		" | hidden: ",
		hidden
	)
