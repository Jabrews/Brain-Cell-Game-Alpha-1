extends Control 

@onready var energy_till_cancel_label : Label = $EnergyTillCancel/EnergyNum
@onready var energy_reward_label : Label = $Reward/EnergyNum
@onready var header_label : Label = $"../HeaderLabel"

# offer requests
@onready var stat_request_parent : Control = $RequestScreens/StatRequest

func _ready() -> void:
	GLShareholderOfferState.connect('recieve_item_offer_demand', _handle_recieve_item_offer)

func _handle_recieve_item_offer(item_offer : ItemOfferDemandConstructor) :
	
	
	header_label.visible = false
	
	visible = true
	
	energy_till_cancel_label.text = str(item_offer.energy_left_to_claim)
	energy_reward_label.text = str(item_offer.energy_reward)
	
	
	match item_offer.demand_type : 	
		'cell' :
			stat_request_parent._load_cell(item_offer.demand_cell)

func _on_button_button_down() -> void:
	header_label.visible = true 
	visible = false
	get_parent().toggle_display_lock(false)
	

func reset_offer_request_screens() :
	stat_request_parent.visible = false
