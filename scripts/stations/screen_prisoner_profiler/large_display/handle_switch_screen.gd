extends Node

# componnets
@onready var stat_display : Control = $"../StatDisplay"
@onready var off_display : Control = $"../OffDisplay"


func _switch(screen_type : String) :

	toggle_screens_off()
	
	match screen_type :	
		'on' : 
			stat_display.visible = true
		'off' :
			off_display.visible = true

func toggle_screens_off() :
	stat_display.visible = false
	off_display.visible = false
	
	
