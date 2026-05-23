extends Node

class_name StatsToHide


var type : String
var quantity : int


@warning_ignore("shadowed_variable")
func _init(type : String, quantity : int) -> void:
	self.type = type
	self.quantity = quantity


func _to_string() -> String:
	return "{type: %s, quantity: %s}" % [
		type,
		quantity
	]
