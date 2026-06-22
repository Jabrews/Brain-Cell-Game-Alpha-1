extends Node

var last_pick_quanity_was_2 = false

func _ready() -> void:
	GLPrisonerPicksBus.connect('generate_next_max_prisoners_created', _handle_generate_next_max_prisoners_created)
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)

func _handle_next_round() :
	last_pick_quanity_was_2 = false

func _handle_generate_next_max_prisoners_created() :
	
	## CURR PRISONERS PICKED ##
	GLPrisonerPicksBus.max_picked_pris_per_turn = GLPrisonerPicksBus.next_max_picked_pris_per_turn
	GLPrisonerPicksBus.curr_picked_pris_per_turn = 0

	GLPrisonerPicksBus.emit_signal('current_max_generated')

	### NEXT PRISONERS PICKED ####
	if last_pick_quanity_was_2 :


		GLPrisonerPicksBus.next_max_picked_pris_per_turn = 1
		last_pick_quanity_was_2 = false

	else :

		var random_choice = randi_range(1, 2)


		GLPrisonerPicksBus.next_max_picked_pris_per_turn = random_choice

		if random_choice == 2 :
			last_pick_quanity_was_2 = true


	GLPrisonerPicksBus.emit_signal('next_max_generated')
