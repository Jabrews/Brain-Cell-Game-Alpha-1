extends Node

class_name SpareIconConstuctor 

var stat : String
var type : String
var direction : String
var start : float
var stop : float


@warning_ignore("shadowed_variable")
func _init(
	stat : String,
	type : String,
	direction : String,
	start : float,
	stop : float,
) -> void:
	self.stat = stat
	self.type = type
	self.direction = direction
	self.start = start
	self.stop = stop


func _to_string() -> String:
	return "[CellConstructor: stat=%s, type=%s, direction=%s, start=%s, stop=%s]" % [
		stat,
		type,
		direction,
		start,
		stop,
	]
