extends Node

# componnets
@onready var stat_offer_card_1 : TextureRect = $ServeStatOffer/Card1Container
@onready var stat_offer_card_2 : TextureRect = $ServeStatOffer/Card2Container
@onready var serve_stat_offer_parent : Control = $ServeStatOffer
@onready var header_label : Label = $HeaderLabel
@onready var blur_bg : ColorRect = $BlurBg


func _ready() -> void:
	GLGameManagerBus.connect('next_turn_process', _handle_next_turn) 

func _handle_next_turn() :
	var curr_turn = GLGameManagerBus.current_turn
	var curr_round  = GLGameManagerBus.current_round
	
	# check for item offer
	if curr_turn == IVShareholderOffers.item_offer_turn :
		handle_item_offer()
	
	# check for stat offer
	if curr_turn == IVShareholderOffers.stat_offer_turn:
		handle_card_offer()
		
		
	
func handle_item_offer() :
	# get random item for card 1
	var item_1 = GLShareholderOfferState.items_to_offer.pick_random()
	GLShareholderOfferState.items_to_offer.erase(item_1)
	
	# get random item for card 2
	var item_2 = GLShareholderOfferState.items_to_offer.pick_random()
	GLShareholderOfferState.items_to_offer.erase(item_2)

	# reset items to offer
	GLShareholderOfferState.items_to_offer = ['defect_shot', 'hidden_shot', 'steroid']

func handle_card_offer() :
	
	var shareholder_stat_offer : Array[StatOfferItem]
	
	# get correct card offers for each round
	var curr_round  = GLGameManagerBus.current_round
	
	match curr_round :
		1 :
			shareholder_stat_offer = GLShareholderOfferState.round_1_stat_offers
		2 :
			shareholder_stat_offer = GLShareholderOfferState.round_2_stat_offers
		3 :
			shareholder_stat_offer = GLShareholderOfferState.round_3_stat_offers
		4 : 
			shareholder_stat_offer = GLShareholderOfferState.round_4_stat_offers
		_ :
			push_error('unable to find round : ', str(curr_round), ' for handle_shareholder_card_offer')
		
	# set cards
	stat_offer_card_1.update(shareholder_stat_offer[0])	
	stat_offer_card_2.update(shareholder_stat_offer[1])	
	toggle_display_lock(true)
	serve_stat_offer_parent.visible = true
	

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

	if offer_type == "stat":
		stat_offer_card_1.visible = false
		stat_offer_card_2.visible = false
	
	
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







	
		
		
		
