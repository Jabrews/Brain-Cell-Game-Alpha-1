extends InteractableBtn 

# components
@onready var on_off_display_label : Label3D = $"../OnOffDisplay"

func _on_btn_interacted():
	GLToggleCleanStatDueOrder.check_for_clean_stat_due_order = !GLToggleCleanStatDueOrder.check_for_clean_stat_due_order 
	
	if GLToggleCleanStatDueOrder.check_for_clean_stat_due_order :
		on_off_display_label.text = 'on'
	else :
		on_off_display_label.text = 'off'
	
	
	
	
	
	
