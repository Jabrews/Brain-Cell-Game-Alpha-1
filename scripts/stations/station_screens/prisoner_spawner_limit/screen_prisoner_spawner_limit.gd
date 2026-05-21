extends Node

# components

@onready var spawner_screen_parent : Control = $SpawnerScreen
@onready var await_compare_screen_parent : Control = $AwaitCompareScreen

@onready var shuffles_left_label : Label = $SpawnerScreen/ShufflesLeftLabel
@onready var current_round_label : Label = $SpawnerScreen/CurrentRoundLabel

func _ready() -> void:
	update_pris_spawner_limit_screen()	
	
	# finale round when no prisoners left to spawn
	GLGameManagerBus.connect('finale_turn', _handle_finale_turn)
	GLGameManagerBus.connect('finale_turn_ended_new_round_proceed', _handle_new_round)
	


func update_pris_spawner_limit_screen() : 
	
	# turn
	var curr_turn = GLGameManagerBus.max_turns - GLGameManagerBus.current_turn
	print('updating update pris spawner limit screen')
	print('max turn : ', GLGameManagerBus.max_turns, ' - ', 'curr turn : ', GLGameManagerBus.current_turn)
	shuffles_left_label.text = str(curr_turn)

	# round
	var curr_round = GLGameManagerBus.current_round
	current_round_label.text = 'Current Round : ' + str(curr_round)

### signal listners ###
func _handle_finale_turn() :
	swap_screen('await_compare')

func _handle_new_round() :
	update_pris_spawner_limit_screen()
	swap_screen('spawner')
######################
	
func swap_screen(screen_type : String) :
	
	spawner_screen_parent.visible = false	
	await_compare_screen_parent.visible = false
	
	match screen_type :
		'spawner' :
			spawner_screen_parent.visible = true
		'await_compare' :
			await_compare_screen_parent.visible = true


	
		
	
	
