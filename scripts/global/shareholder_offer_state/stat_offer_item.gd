extends Node

class_name StatOfferItem

var effect_type : String
var offer_id : int
var flavor_text : String


func _init(
	new_effect_type : String,
	new_offer_id : int,
	new_flavor_text : String
):
	effect_type = new_effect_type
	offer_id = new_offer_id
	flavor_text = new_flavor_text


func _to_string() -> String:
	return (
		"StatOfferItem(" +
		"effect_type=" + effect_type+
		", offer_id=" + str(offer_id) +
		", flavor_text=" + flavor_text +
		")"
	)
