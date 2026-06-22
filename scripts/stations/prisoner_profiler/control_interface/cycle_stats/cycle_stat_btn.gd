extends InteractableBtn

@export var cycle_direction : String = 'up'

@onready var handle_cycle_stat : Node = $"../../../Logic/HandleCycleStat"

func _on_btn_interacted() :
	handle_cycle_stat._stat_cycle_btn_down(cycle_direction)
