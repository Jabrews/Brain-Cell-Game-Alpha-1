extends Node

# componnets
#@onready var serve_stat_offer_parent : Control = $ServeStatOffer
@onready var serve_item_offer_parent : Control = $ServeItemOffer
@onready var header_label : Label = $HeaderLabel
@onready var blur_bg : ColorRect = $BlurBg
# cards 
#@onready var stat_offer_card_1 : TextureRect = $ServeStatOffer/Card1Container
#@onready var stat_offer_card_2 : TextureRect = $ServeStatOffer/Card2Container
@onready var item_offer_card_1 : TextureRect = $ServeItemOffer/Card1Container
@onready var item_offer_card_2 : TextureRect = $ServeItemOffer/Card2Container
# helpers
@onready var helper_stat_offer_active_toggle : Node = $HelperStatOfferActiveToggle

var has_offered_stat : bool = false
var has_offered_item : bool = false


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn_changed)

func _handle_energy_turn_changed() :

	var curr_energy = GLGameManagerBus.curr_energy
	var max_energy = GLGameManagerBus.max_energy

	var energy_percent : float = (curr_energy / float(max_energy)) * 100.0

	if energy_percent <= IVShareholderOffers.item_offer_energy_percant :
		has_offered_item = true
		handle_item_offer()
		return

func _handle_next_round() :
	helper_stat_offer_active_toggle._handle_reset_active_stat_offer()
	has_offered_item = false
	has_offered_stat = false
	
func handle_item_offer() :
	
	var item_to_offer_copy = GLShareholderOfferState.items_to_offer
	
	# get random item for card 1
	var item_1 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_1)
	
	# get random item for card 2
	var item_2 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_2)

	# set cards
	item_offer_card_1.update(item_1)	
	item_offer_card_2.update(item_2)	
	toggle_display_lock(true)
	serve_item_offer_parent.visible = true

func handle_card_picked(offer_type : String, offer_card : TextureRect) :
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# move card downward off screen
	tween.tween_property(
		offer_card,
		"position:y",
		offer_card.position.y + 300,
		0.8
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	# fade out
	tween.parallel().tween_property(
		offer_card,
		"modulate:a",
		0.0,
		0.8
	)

	await tween.finished

	toggle_display_lock(false)

	if offer_type == 'item' :
		serve_item_offer_parent.visible = false
		var item_offer : UseableOfferItem = offer_card.designated_useable_item_offer 
		GLShareholderOfferState.emit_signal('spawn_item_to_offer', item_offer)
		
	
	
func toggle_display_lock(toggleValue : bool) :
	
	if toggleValue :
		header_label.visible = true
		blur_bg.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	else :
		header_label.visible = false
		blur_bg.visible = false 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false 







	
		
		
		
