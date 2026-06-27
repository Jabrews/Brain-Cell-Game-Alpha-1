extends Node

class_name StatConstructor

var stat_type : String
var stat_base_clean_value : float
var spare_symbol : StatSpareSymbol
var stat_enabled : bool


@warning_ignore("shadowed_variable")
func _init(
	stat_type : String,
	stat_base_clean_value : float,
	spare_symbol: StatSpareSymbol,
	stat_enabled : bool = true
) -> void:

	self.stat_type = stat_type
	self.stat_base_clean_value = stat_base_clean_value
	self.spare_symbol = spare_symbol
	self.stat_enabled = stat_enabled


func _to_string() -> String:
	return "[StatConstructor: stat_type=%s, stat_base_clean_value=%s, spare_symbol=%s, stat_enabled=%s]" % [
		stat_type,
		stat_base_clean_value,
		spare_symbol,
		stat_enabled
	]
