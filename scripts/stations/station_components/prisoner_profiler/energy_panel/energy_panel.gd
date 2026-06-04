extends Node

@onready var curr_energy_label : Label3D = $CurrEnergy
@onready var used_energy_label : Label3D = $EnergyUsed
@onready var left_over_energy_label : Label3D = $EnerfyLeft

var energy_left : int = 100


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)

func _handle_next_round() :
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	used_energy_label.text = str(10)
	left_over_energy_label.text = str(GLGameManagerBus.curr_energy)


func handle_energy_to_spend_change(energy_to_spend: int) :
	
	# update curr energy label
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	
	# update energy were spending 
	used_energy_label.text = str(energy_to_spend)
	
	# set left over energy after potential change
	energy_left = GLGameManagerBus.curr_energy - energy_to_spend
	left_over_energy_label.text = str(energy_left)
	
func _handle_profiler_prisoners_generated() : 		
	
	GLGameManagerBus.curr_energy = energy_left 
	
	#used_energy_label.text = str(10)
	#print(used_energy_label.text)
	
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	
	
	
