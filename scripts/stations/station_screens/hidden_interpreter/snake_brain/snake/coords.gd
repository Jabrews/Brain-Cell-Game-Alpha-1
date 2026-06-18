extends Node

class_name Coord

var x : float
var y : float


@warning_ignore("shadowed_variable")
func _init(
	x : float,
	y : float,
):
	self.x = x
	self.y = y 


func _to_string() -> String:
	return "x: %s, y: %s" % [str(self.x), str(self.y)]
