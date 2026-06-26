extends Node

@onready var spare_symbol_updater : Node = $SpareSymbolsUpdater

var selected_stat_selected_icons : Dictionary


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('recieve_profiler_spare_icons', _handle_recieve_profiler_spare_icons)

func _generate_spare() :
	selected_stat_selected_icons = {}
	GLPrisonerProfilerComponentsBus.emit_signal('request_new_profiler_spare_icons')


func _handle_recieve_profiler_spare_icons(stat_selected_icons : Dictionary) :
	
	selected_stat_selected_icons = stat_selected_icons	
	
	spare_symbol_updater._update_large_stat_screens(selected_stat_selected_icons)



	
	
