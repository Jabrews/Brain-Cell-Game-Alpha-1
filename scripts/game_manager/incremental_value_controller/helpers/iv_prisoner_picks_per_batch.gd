extends Node


var last_pick_quanity_was_2 : bool = false


func _prisoner_picks_per_batch() :
	
	# reset 
	IVPrisonerSpawner.curr_picked_pris_per_turn = 0
	
	if last_pick_quanity_was_2 : 	
		IVPrisonerSpawner.max_picked_pris_per_turn = 1
		last_pick_quanity_was_2 = false
	
	else :
		var random_choice = randi_range(1,2)
		IVPrisonerSpawner.max_picked_pris_per_turn = random_choice
		
		if random_choice == 2 :
			last_pick_quanity_was_2 = true
			
	
	
