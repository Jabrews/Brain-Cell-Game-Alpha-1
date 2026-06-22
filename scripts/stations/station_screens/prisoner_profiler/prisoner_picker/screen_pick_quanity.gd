extends Node

# components
@onready var pick_num_left_label : Label = $PickNum

func _ready() -> void:
	GLPrisonerPicksBus.connect('next_max_generated', _handle_next_max_generated)
	pick_num_left_label.text = '1'
	
	
func _handle_next_max_generated() :
	pick_num_left_label.text = str(GLPrisonerPicksBus.next_max_picked_pris_per_turn)
	
	
	
