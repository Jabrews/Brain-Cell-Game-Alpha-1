extends Node

class_name UseableItemObject 
var item_id : int
var item_type: String
var item_has_energy: bool
var item_energy: int

@warning_ignore("shadowed_variable")
func _init(item_id, item_type: String , item_has_energy: bool, item_energy: int = 0) -> void:
	self.item_id = item_id
	self.item_type = item_type
	self.item_has_energy = item_has_energy
	self.item_energy = item_energy

func _to_string() -> String:
	return "[UseableItemObject: id=%s, type=%s, has_energy=%s, energy=%s]" % [
		item_id,
		item_type,
		item_has_energy,
		item_energy
	]
