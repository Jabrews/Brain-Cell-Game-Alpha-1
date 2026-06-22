extends InteractableBtn

@export var increment_direction : String = 'up'

@onready var handle_increment_stat : Node = $"../../../Logic/HandleIncrementStat"


func _on_btn_interacted(): 
	handle_increment_stat._handle_increment_btn_down(increment_direction)
