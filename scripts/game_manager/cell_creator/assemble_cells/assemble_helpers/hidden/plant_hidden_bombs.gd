extends Node

var just_planted_bomb : bool = false

func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)

func _handle_next_round() :
	just_planted_bomb = false

func _check_can_plant_bombs() :
	
	# round isnt atleast 3
	if GLGameManagerBus.current_round < 3 :
		return false
	# energy is larger than 75%
	elif GLGameManagerBus.curr_energy >= GLGameManagerBus.max_energy * 0.75: 
		return false
	# we just planted bomb
	elif just_planted_bomb :
		just_planted_bomb = false
		return false
	# else its okay to plant bomb
	else :
		# chance to still not plant bombs	
		var random_chance = randi_range(0, 100)	
		if random_chance >= 30 : 
			return false
		else :
			return true
	
func _plant_hidden_bombs(new_prisoners : Array[BrainCell]) :
	
	var max_bomb_quanity = IVHiddenStats.total_possible_hidden_bombs
	var curr_bomb_quanity = 0
	
	while curr_bomb_quanity < max_bomb_quanity:
		
		var prisoner : BrainCell = new_prisoners.pick_random()
		var possible_stats : Array[String] = ["strength", "intelligence", "community"]
		var bomb_planted = false
		
		while not bomb_planted and possible_stats.size() > 0:
			
			var random_index = randi_range(0, possible_stats.size() - 1)
			var random_stat_choice = possible_stats[random_index]
			
			match random_stat_choice:
				
				"strength":
					if prisoner.strength.hidden:
						prisoner.strength.defect += IVCellCreator.max_stat_value * 0.60
						prisoner.strength.defect = clamp(
							prisoner.strength.defect,
							0,
							IVCellCreator.max_stat_value
						)
						print('planted bomb on : ', prisoner.name)
						bomb_planted = true
					else:
						possible_stats.erase(random_stat_choice)
				
				"intelligence":
					if prisoner.intelligence.hidden:
						prisoner.intelligence.defect += IVCellCreator.max_stat_value * 0.60
						prisoner.intelligence.defect = clamp(
							prisoner.intelligence.defect,
							0,
							IVCellCreator.max_stat_value
						)
						print('planted bomb on : ', prisoner.name)
						bomb_planted = true
					else:
						possible_stats.erase(random_stat_choice)
				
				"community":
					if prisoner.community.hidden:
						prisoner.community.defect += IVCellCreator.max_stat_value * 0.60
						prisoner.community.defect = clamp(
							prisoner.community.defect,
							0,
							IVCellCreator.max_stat_value
						)
						print('planted bomb on : ', prisoner.name)
						bomb_planted = true
					else:
						possible_stats.erase(random_stat_choice)
		
		if bomb_planted:
			curr_bomb_quanity += 1
		else:
			break
	
	just_planted_bomb = true
	
	return new_prisoners
