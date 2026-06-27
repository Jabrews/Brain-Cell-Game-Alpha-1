extends Node

@onready var spare_symbol_updater : Node = $SpareSymbolsUpdater

var selected_spare_icon_constructors: Array[SpareIconConstuctor]


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('recieve_profiler_spare_icons', _handle_recieve_profiler_spare_icons)

func _generate_spare() :
	selected_spare_icon_constructors = []
	GLPrisonerProfilerComponentsBus.emit_signal('request_new_profiler_spare_icons')


func _handle_recieve_profiler_spare_icons(spare_item_constuctors: Array[SpareIconConstuctor]) :
	
	selected_spare_icon_constructors = spare_item_constuctors 
	
	spare_symbol_updater._update_large_stat_screens(selected_spare_icon_constructors)



	
	
