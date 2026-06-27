extends Node

class_name StatSpareSymbol

var type : String
var direction : String


@warning_ignore("shadowed_variable")
func _init(
	type : String = '',
	direction : String = '',
) -> void:

	self.type  = type
	self.direction = direction

func _to_string() -> String:
	return "[StatConstructor: type=%s, direction=%s]" % [
		type,
		direction
	]
