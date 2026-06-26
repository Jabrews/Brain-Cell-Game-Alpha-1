extends Node

# components
@onready var curr_energy_label : Label3D = $"../../../EnergyDisplay/EnergyPanel/CurrEnergy"
@onready var energy_used_label : Label3D = $"../../../EnergyDisplay/EnergyPanel/EnergyUsed"
@onready var energy_used_sprite : Sprite3D = $"../../../EnergyDisplay/EnergyPanel/EnergyIcon2"
@onready var energy_left_label : Label3D = $"../../../EnergyDisplay/EnergyPanel/EnerfyLeft"
@onready var helper_handle_energy : Node = $".."

func _update() :
	
	var total = helper_handle_energy.get_total_energy_used()
	
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	handle_update_energy_used(total)
	energy_left_label.text = str(GLGameManagerBus.curr_energy + total)

func handle_update_energy_used(total : int) :
	
	if total <= 0 :
		energy_used_label.modulate = Color.RED
		energy_used_sprite.modulate = Color.RED
		energy_used_label.text = str(total)
		
	else : 
		energy_used_label.modulate = Color.GREEN
		energy_used_sprite.modulate = Color.GREEN
		energy_used_label.text = '+' + str(total)
		
	
	
	
	
	
	
	
	
	
	
	
