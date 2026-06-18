extends Node

@onready var idle_screen : Control =$"../IdleScreen"
@onready var no_cell_detected_screen : Control  = $"../NoCellDetected"
@onready var no_hidden_stat_detected_screen : Control  =$"../NoHiddenStatDetected"
@onready var jolt_detected_screen : Control = $"../JoltDetectedPleaseReset"
@onready var finished_screen : Control = $"../Finished"
@onready var station_parent : Node3D = $"../../../../.."

var game_screen_scene: PackedScene 


func _ready() -> void:
	game_screen_scene = station_parent.game_screen_scene 

func _switch(screen_type : String, info_screen_type) :
	
	toggle_all_screens_off()	
	
	if screen_type == 'INFO_SCREEN' :
		
		match info_screen_type :
			'NO_CELL_DETECTED' :
				no_cell_detected_screen.visible = true
			'INVALID_STAT' :
				no_hidden_stat_detected_screen.visible = true
			'JOLT' :
				jolt_detected_screen.visible = true
			'FINISHED' :
				finished_screen.visible = true
		
	if screen_type == 'IDLE_SCREEN':	
		idle_screen.visible = true
	
	if screen_type == 'GAME_SCREEN' :
		create_and_switch_game_screen()
	
func toggle_all_screens_off() :
	idle_screen.visible = false
	no_cell_detected_screen.visible = false
	no_hidden_stat_detected_screen.visible = false
	jolt_detected_screen.visible = false
	finished_screen.visible = false
	
	if get_parent().game_screen_instance :	
		get_parent().game_screen_instance.visible = false
		get_parent().game_screen_instance.queue_free()
	

func create_and_switch_game_screen() :
	# instiante
	var game = game_screen_scene.instantiate()
	# set name
	game.name = 'GameScreen'
	# add to main tree
	get_parent().add_child(game)
	# set var	
	get_parent().game_screen_instance = game
	
	# kinda hacky but works
	# let it update time on startup	
	var timer_increment_helper = get_parent().parent_station_interpreter.timer_increment
	get_parent().game_screen_instance._handle_increment(timer_increment_helper.current_time_increment)

	
	
	
	
	
	
	
