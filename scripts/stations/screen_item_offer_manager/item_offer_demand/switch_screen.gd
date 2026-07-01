extends Node

# main displays
@onready var demand_display : Control = $"../Demand"
@onready var no_demand_display : Control = $"../NoDemand"

# demands
@onready var stat_demand : Control = $"../Demand/StatDemand"

# confirm / fail
@onready var fail_screen : Control = $"../Fail"
@onready var confirm_screen : Control = $"../Confirm"



func _toggle_active_offer(toggle_value : bool):
	match toggle_value :
		true :
			demand_display.visible = true
			no_demand_display.visible = false
		false :
			demand_display.visible = false 
			no_demand_display.visible = true 

func _switch_offer_screen(offer_type : String) :
	match offer_type :
		'cell' :
			stat_demand.visible = true
		_ : 
			stat_demand.visible = false

func _play_confirmation_screen(screen_type : String) :
	match screen_type: 
		'confirm': 
			confirm_screen.visible = true
			fail_screen.visible = false
		'fail' : 
			confirm_screen.visible = false
			fail_screen.visible = true
			
			await get_tree().create_timer(10.0).timeout
			fail_screen.visible = false
			
			
		'none': 
			confirm_screen.visible = false
			fail_screen.visible = false 
			
			
