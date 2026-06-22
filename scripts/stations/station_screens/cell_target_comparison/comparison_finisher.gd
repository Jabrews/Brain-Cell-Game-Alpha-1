extends Node

var target_cell : BrainCell

# components
@onready var screen_swap_handler : Node = $ComparisonScreenSwapHandler
@onready var next_round_delay_timer : Timer = $NextRoundDelayTimer




func _ready() -> void:
	GLCellManagerBus.connect('target_cell_created', _handle_target_cell_created)
	
	# game loop logic once finished round and displaying passed screeen
	next_round_delay_timer.connect('timeout', _handle_next_round_delay_timer_timeout)


func _handle_target_cell_created(new_target_cell : BrainCell) :
	target_cell = new_target_cell
	
	
### MATH COMPARE ###
func compare_cells(selected_brain_cell : BrainCell) :
	
	if not selected_brain_cell :
		return
	
	# quick check to see if cell has any disabled stats. 	
	var invalid_stat = check_for_disabled_stats(selected_brain_cell)
	if invalid_stat :
		handle_compare_finished(false)
		return
	
	
	# 0 (nothing like target stats)
	# 100 (exavtly like target stats)
	var max_points : int = 100
	
	# get diffrence in each stat
	var str_point_diffrence = compare_stat(target_cell.strength.value, selected_brain_cell.strength.value)	
	var int_point_diffrence = compare_stat(target_cell.intelligence.value, selected_brain_cell.intelligence.value)	
	var com_point_diffrence = compare_stat(target_cell.community.value, selected_brain_cell.community.value)	
	
	# apply points to max
	var total_point_diff = str_point_diffrence + int_point_diffrence + com_point_diffrence
	max_points -= total_point_diff	
	
	# debug
	#print('total point diff : ', max_points)
	
	# see if max points around above 80
	if max_points >= 40: 
		handle_compare_finished(true)
	else :
		handle_compare_finished(true)
		#handle_compare_finished(false)
	
func compare_stat(target_stat : float, selected_stat : float) :
	
	
	# see if within 20 points. 	
	# if so dont subtract points
	if selected_stat > target_stat - 20 and selected_stat < target_stat + 20 :
		
		return 0 	
	
	# see if below 
	elif selected_stat < target_stat :
		var stat_diffrence = target_stat - selected_stat	
		
		# if below we slightly increase diffrence
		stat_diffrence += stat_diffrence * 0.5
		
		return stat_diffrence
	
	# see if above
	elif selected_stat > target_stat :
		var stat_diffrence = selected_stat - target_stat 
		# if above we treat slightly nicer
		stat_diffrence *= 0.8
		
		return stat_diffrence
	
####################

### GAME LOOP LOGIC ###
func handle_compare_finished(comparison_success : bool) :
	if comparison_success:
		screen_swap_handler.swap_screen('compare_passed')
		get_parent().can_accept_cell = false		
		next_round_delay_timer.start()
		
	else : 
		screen_swap_handler.swap_screen('compare_failed')

func _handle_next_round_delay_timer_timeout() :
	GLGameManagerBus.emit_signal('proceed_next_round')
	screen_swap_handler.swap_screen('target_stat_display')
	get_parent().can_accept_cell = true 
#######################

func check_for_disabled_stats(selected_brain_cell : BrainCell) :
	var cell_missing_stat : bool = false
	if not selected_brain_cell.strength.enabled :
		cell_missing_stat = true
	if not selected_brain_cell.intelligence.enabled :
		cell_missing_stat = true	
	if not selected_brain_cell.community.enabled:
		cell_missing_stat = true	

	return cell_missing_stat
	
	
