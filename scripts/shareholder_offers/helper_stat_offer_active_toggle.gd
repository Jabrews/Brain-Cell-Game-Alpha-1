extends Node


func _handle_toggle_active_stat_offer(offer_id : int) :
	
	match offer_id : 
		1 : 
			GLShareholderOfferState.offer_1_active = true
		2 : 
			GLShareholderOfferState.offer_2_active = true		
		3 : 
			GLShareholderOfferState.offer_3_active = true		
		4 : 
			GLShareholderOfferState.offer_4_active = true				
		5 : 
			GLShareholderOfferState.offer_5_active = true 
		6 : 
			GLShareholderOfferState.offer_6_active = true				
		7 : 
			GLShareholderOfferState.offer_7_active = true						
		8 : 
			GLShareholderOfferState.offer_8_active = true								

func _handle_reset_active_stat_offer() :
	GLShareholderOfferState.offer_1_active = false 
	GLShareholderOfferState.offer_2_active = false 
	GLShareholderOfferState.offer_3_active = false 
	GLShareholderOfferState.offer_4_active = false 
	GLShareholderOfferState.offer_5_active = false 
	GLShareholderOfferState.offer_6_active = false 
	GLShareholderOfferState.offer_7_active = false 
	GLShareholderOfferState.offer_8_active = false 
