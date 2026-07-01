extends Node

# componnets
@onready var serve_item_offer_parent : Control = $ServeItemOffer
@onready var header_label : Label = $HeaderLabel
@onready var blur_bg : ColorRect = $BlurBg
# cards 
@onready var item_offer_card_1 : TextureRect = $ServeItemOffer/Card1Container
@onready var item_offer_card_2 : TextureRect = $ServeItemOffer/Card2Container


var has_served_energy_based_card : bool = false
var has_served_second_card : bool = false



func _ready() -> void:
	#GLGameManagerBus.connect('proceed_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn_changed)
	GLGameManagerBus.connect('energy_changed', _handle_energy_turn_changed)
	GLShareholderOfferState.connect('item_offer_success', _handle_item_offer_success)

func _handle_energy_turn_changed() :

	var curr_energy = GLGameManagerBus.curr_energy
	var max_energy = GLGameManagerBus.max_energy

	var energy_percent : float = (curr_energy / float(max_energy)) * 100.0

	if energy_percent <= IVShareholderOffers.item_offer_energy_percant and not has_served_energy_based_card:
		serve_item_cards()
		has_served_energy_based_card = true
	
	# first round doesnt care about request just give another card after first one 
	elif energy_percent <= IVShareholderOffers.first_round_item_offer_energy_percant and not has_served_second_card : 
		serve_item_cards()
	

func _handle_next_round() :
	has_served_energy_based_card = false
	has_served_second_card = false

func serve_item_cards() :
	
	toggle_display_lock(true)
	
	serve_item_offer_parent.visible = true
	
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
	
func handle_card_picked(offer_card : TextureRect) :
	
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
		
	serve_item_offer_parent.visible = false	
		
	var item_offer : UseableOfferItem = offer_card.designated_useable_item_offer 
	GLShareholderOfferState.emit_signal('spawn_item_to_offer', item_offer)
	
	
	if not has_served_second_card and not GLGameManagerBus.current_round == 1 : # first round doesnt care
		GLShareholderOfferState.emit_signal('create_item_offer_demand')
	else : 
		toggle_display_lock(false)
		
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
		
		
func _handle_item_offer_success() :
	serve_item_cards()

		
		
		
		
