extends Node

# components
@onready var current_round_label : Label3D =$CurrentRound
@onready var current_turn_label : Label3D = $CurrentTurn


func _ready() -> void:
	update_label_display()



func _handle_round_controller_increment_up_btn(cycle_type : String, increment_type : String) :
	if cycle_type == 'round' :
		if increment_type == 'up' :
			GLGameManagerBus.current_round += 1	
		elif increment_type == 'down' :
			GLGameManagerBus.current_round += -1
		else :
			push_error('non valid increment type found from btn press')
	elif cycle_type == 'turn' :
		if increment_type == 'up' :
			GLGameManagerBus.current_turn += 1	
		elif increment_type == 'down' :
			GLGameManagerBus.current_turn -= 1	
		else :
			push_error('non valid increment type found from btn press')
	else :
		push_error('non valid round/turn type found from btn press')
	
	update_label_display()
	GLIncrementalValueControllerBus.emit_signal('progression_change', GLGameManagerBus.current_round, GLGameManagerBus.current_turn)

		
func update_label_display() :
	current_round_label.text = str(GLGameManagerBus.current_round)
	current_turn_label.text =  str(GLGameManagerBus.current_turn)
	
	
