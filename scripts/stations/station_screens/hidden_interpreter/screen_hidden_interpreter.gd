extends Node

# componnets
@onready var handle_switch_screen : Node = $HandleSwitchScreen
@onready var idle_screen : Control = $IdleScreen
@onready var parent_station_interpreter : Node3D = $"../../../.."
var game_screen_instance : Node2D 

@onready var stat_names_labels : Array[Label] = [
	$IdleScreen/StatName,
	$NoCellDetected/StatName,
	$JoltDetectedPleaseReset/StatName
]


func _ready() -> void:
	# load correct stat type name into screens
	for label : Label in stat_names_labels :
		label.text = str(parent_station_interpreter.interpreter_type)

func _switch_screen(screen_type : String, info_screen_type) :
	handle_switch_screen._switch(screen_type, info_screen_type)

func _handle_timer_increment(current_value : int) :
	idle_screen._handle_increment(current_value)
	
	if game_screen_instance :
		game_screen_instance._handle_increment(current_value)
	

func _handle_timer_reset() :
	idle_screen._reset_increment()

	
