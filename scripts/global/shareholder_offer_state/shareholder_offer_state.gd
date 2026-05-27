extends Node

##### item offer #####
var items_to_offer = ['defect_shot', 'hidden_shot', 'steroid']
######################

var round_1_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_prisoners', 1, 'Only 3 prisoners can be picked throughout the round, but their clean stats are moderately better.'
	),
	StatOfferItem.new(
		'effects_breeding', 2, 'All breeding results gain 15% increased clean stats, but defect increases by 20%.'
	)
]
var round_2_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_defect', 3, 'All newly generated cells have no defect, but none are infected and cannot birth brain spiders.'
	),
	StatOfferItem.new(
		'effects_prisoners', 4, 'Greatly reduces hidden stats, but remaining hidden stats are more likely to hide high infection.'
	)
]
var round_3_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_defect', 5, 'Reduce defect event chance by 15%, but increase defect on new cells by 15%.'
	),
	StatOfferItem.new(
		'effects_defect', 6, 'Increase hidden stat interpreter jolts by 15%, but reduce overall defect event chance by 10%.'
	)
]
var round_4_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_defect', 7, 'Reduce defect event chance by 15%, but jolted cells now increase defect much more aggressively.'
	),
	StatOfferItem.new(
		'effects_prisoners', 8, 'All collected cells lifespan become 1 turn, but newly generated cells have low defect.'
	)
]

##### stat offer #####
## round 1 ##
# only 3 prisoners to pick throughout the round, but the clean stat value is moderatly better
var offer_1_active : bool = false
# all cell breeding results give 15% increase (phase 3) but defect gives 20%
var offer_2_active : bool = false
## round 2 ##
# all cells for the next generation-turn have no defect, but no one is "infected"  and will birth a brain spider 
var offer_3_active : bool = false
# greatly reduce the amount of hidden stats, but increase the chance of the remaining hiding high infection (can start bombs early round 2)
var offer_4_active : bool = false
## round 3 ##
# reduce chance of defect event by 15%. Increase defect on new cells by 15%
var offer_5_active : bool = false
# increase chance of all hidden stat interpreters jolt by 15%. but reduce overall chance of defect/event by 10%
var offer_6_active : bool = false
## round 4 ##
# decrease the chance of defect events to occur by 15%. But a jolted cell now increases at a much more aggressive rate
var offer_7_active : bool = false
# all collected cells lifespan are set to 1 (will die next turn) but the newly generated cells have low defect
var offer_8_active : bool = false
#######################
