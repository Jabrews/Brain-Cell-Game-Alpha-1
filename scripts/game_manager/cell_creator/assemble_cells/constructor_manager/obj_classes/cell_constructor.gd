extends Node

class_name CellConstructor

var cell_quantity : int
var clean_ranges : String
var defect_ranges : Array[String]
var stats_to_hide : Array[StatsToHide]


@warning_ignore("shadowed_variable")
func _init(
	cell_quantity : int,
	clean_ranges : String,
	defect_ranges : Array[String],
	stats_to_hide : Array[StatsToHide]
) -> void:
	
	self.cell_quantity = cell_quantity
	self.clean_ranges = clean_ranges
	self.defect_ranges = defect_ranges
	self.stats_to_hide = stats_to_hide


func _to_string() -> String:
	return "[CellConstructor: quantity=%s, clean_ranges=%s, defect_ranges=%s, stats_to_hide=%s]" % [
		cell_quantity,
		clean_ranges,
		defect_ranges,
		stats_to_hide
	]
