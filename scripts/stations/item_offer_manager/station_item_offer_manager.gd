extends Node

@onready var screen_demand_display : Node2D = $Displays/DemandDisplay/SubViewport/ItemOfferDemand
@onready var screen_energy_left_to_claim : Node2D = $Displays/EnergyLeftToClaimDisplay/SubViewport/EnergyLeftToClaimDisplay
@onready var screen_reward_energy  : Node2D = $Displays/RewardEnergyDisplay/SubViewport/ScreenEnergyReward
@onready var audio_manager : Node3D = $AudioManager

var selected_offer_demand_constructor : ItemOfferDemandConstructor = null

var waiting_for_confirm_btn : bool = false


func _ready() -> void:
	GLShareholderOfferState.connect('recieve_item_offer_demand', _handle_recieve_item_offer_demand)


#### OFFER RECIEVED #####
func _handle_recieve_item_offer_demand(offer_demand_constructor : ItemOfferDemandConstructor) :
	
	selected_offer_demand_constructor = offer_demand_constructor	
	
	toggle_switch_active_offer(true)
	
	screen_demand_display.switch_screen._switch_offer_screen(offer_demand_constructor.demand_type)
	screen_demand_display._load_demand(offer_demand_constructor.demand_type)
		
	screen_energy_left_to_claim._load_inital_energy_left(offer_demand_constructor.energy_left_to_claim)
	screen_reward_energy._load_reward(offer_demand_constructor.energy_reward)
###########################


### CELL RECIEVED / SEEING IF SUCESS ####
func _handle_panel_body_recieved(brain_cell_body : CharacterBody3D) :
	if brain_cell_body : 	
	
		var selected_brain_cell : BrainCell = brain_cell_body.designated_brain_cell	
		
		GLPlayerLocalSoundsBus.emit_signal('sound_panel_cell_loaded')
		
		if selected_offer_demand_constructor : 	
			var sucess = screen_demand_display._handle_cell_recieved(selected_offer_demand_constructor, selected_brain_cell)		
				
			if sucess : 			
				handle_offer_success()
			else : 
				handle_offer_failed()
				
			
		else : 
			GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
			waiting_for_confirm_btn = false
	else : 
		screen_demand_display.switch_screen._play_confirmation_screen('none')
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		waiting_for_confirm_btn = false
######################
		
	
##### HELPERS ######
func toggle_switch_active_offer(toggle_value : bool) :
	screen_demand_display.switch_screen._toggle_active_offer(toggle_value)
	screen_energy_left_to_claim.switch_screen._toggle_active_offer(toggle_value)
	screen_reward_energy.switch_screen._toggle_active_offer(toggle_value)
####################
	
#### EXSPIRE / CONFIRM #####

## called when energy runs out
func _handle_offer_energy_exspired() :	
	
	waiting_for_confirm_btn = false	
	
	# get rid of offer
	selected_offer_demand_constructor = null	
	
	 #toggle dissabled
	toggle_switch_active_offer(false)
	
	# reset label
	screen_energy_left_to_claim.reset_label()	
	
	# play fail
	audio_manager.play_fail()
	
	screen_demand_display.switch_screen._play_confirmation_screen('fail')
	
## called when sucess cell is loaded
func handle_offer_success() :
	
	screen_demand_display.switch_screen._play_confirmation_screen('confirm')
	
	audio_manager.play_success()
	
	waiting_for_confirm_btn = true	
	
	
func _handle_confirm_btn_pressed() :
	toggle_switch_active_offer(false)
	
	screen_demand_display.switch_screen._play_confirmation_screen('none')
	
	audio_manager.play_confirm()
	
	GLGameManagerBus.curr_energy += selected_offer_demand_constructor.energy_reward
	GLGameManagerBus.emit_signal('energy_changed')
	
	await get_tree().create_timer(1.0).timeout
	
	GLShareholderOfferState.emit_signal('item_offer_success')
	
	selected_offer_demand_constructor = null	


## called when failed
func handle_offer_failed() :
	
	waiting_for_confirm_btn = false 
	
	screen_demand_display.switch_screen._play_confirmation_screen('fail')

	# play fail
	audio_manager.play_fail()
	
#############################
	
	
	
	
