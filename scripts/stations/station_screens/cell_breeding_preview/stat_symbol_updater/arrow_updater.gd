extends  Node 


# components
# STRENGTH
@onready var strength_arrow_up : Sprite2D = $"../../Symbols/Arrows/StrengthArrows/Up"
@onready var strength_arrow_down : Sprite2D = $"../../Symbols/Arrows/StrengthArrows/Down"

# INTELLIGENCE
@onready var intelligence_arrow_up : Sprite2D = $"../../Symbols/Arrows/IntelligenceArrows/Up"
@onready var intelligence_arrow_down : Sprite2D =$"../../Symbols/Arrows/IntelligenceArrows/Down"

# COMMUNITY
@onready var community_arrow_up : Sprite2D = $"../../Symbols/Arrows/CommunityArrows/Up"
@onready var community_arrow_down : Sprite2D = $"../../Symbols/Arrows/CommunityArrows/Down"


################ HANDLE ARROW TYPE ###############

func _handle_arrow_type(key : String, cell_left : BrainCell, cell_right: BrainCell) -> String :
	
	# [0] = high
	var high_low_stat : Array
	
	# target cell
	var target_cell = GLCellManagerBus.target_cell_refrence
	var target_stat : float = 0.0
	
	
	# get highest lowest stat
	match key : 
		'str'  :
			high_low_stat = get_highest_lowest_stat(
				cell_left.strength.value,
				cell_right.strength.value
			)
			target_stat = target_cell.strength.value
			
			
		'int' : 
			high_low_stat = get_highest_lowest_stat(
				cell_left.intelligence.value,
				cell_right.intelligence.value
			)
			target_stat = target_cell.intelligence.value
			
		'com' :
			high_low_stat = get_highest_lowest_stat(
				cell_left.community.value,
				cell_right.community.value
			)
			target_stat = target_cell.community.value
			
		_:		
			push_error('no key value found for _handle_detect_over_warning')
		
	## CHECK IF INCREASING 
	var confirm_increase_event : bool = detect_increasing_event(
		high_low_stat,
		target_stat,
	)
	
	if confirm_increase_event :
		return 'up'
	else :
		return 'down'
	
	
func detect_increasing_event(high_low_stat : Array, target_stat : float ) -> bool :
	
	# see if it reaches minimum passing increase score
	var increase_case_min = (
		high_low_stat[0]
		* IVCellBreeding.clean_stat_increase_case_min
	)
#
	if high_low_stat[1] >= increase_case_min :
		return true
	else :
		
		# check if early game small stats
		var small_stat_range_max = target_stat * 0.2	
		# both stats are below 20% of target
		if high_low_stat[0] < small_stat_range_max and high_low_stat[1] < small_stat_range_max :
			return true
			
		# else its not a increasing case
		else : 
			return false
		
		
func get_highest_lowest_stat(stat_1, stat_2) :
	var high_stat : float
	var low_stat : float
	
	if stat_1 >= stat_2 :
		high_stat = stat_1
		low_stat = stat_2
	else :
		high_stat = stat_2
		low_stat = stat_1
	
	return [high_stat, low_stat]

##################################################

################ HANDLE ARROW PHASE ###############
func _handle_arrow_phase(arrow_type_active : String, key : String, cell_left: BrainCell, cell_right: BrainCell) -> int:
	
	# get high low stat
	var high_low_stat : Array
	
	var target_cell = GLCellManagerBus.target_cell_refrence
	var target_stat : float # NOTE : this isnt used till % 
	
	# get highest lowest stat
	match key : 
		'str'  :
			high_low_stat = get_highest_lowest_stat(
				cell_left.strength.value,
				cell_right.strength.value
			)
			target_stat = target_cell.strength.value
			
		'int' : 
			high_low_stat = get_highest_lowest_stat(
				cell_left.intelligence.value,
				cell_right.intelligence.value
			)
			target_stat = target_cell.intelligence.value
			
		'com' :
			high_low_stat = get_highest_lowest_stat(
				cell_left.community.value,
				cell_right.community.value
			)
			target_stat = target_cell.community.value
			
		_:		
			push_error('no key value found for _handle_detect_over_warning')

	# find finale value after increase decrease logic (not simple)
	var finale_value
	match arrow_type_active :
		'up' :
			var inrease_clean_stat_case = IncreaseCleanStatCase.new()
			finale_value = inrease_clean_stat_case.increase_clean_stat_case(high_low_stat[0], high_low_stat[1], target_stat)
		'down' :
			var decrease_clean_stat_case = DecreaseCleanStatCase.new()
			finale_value = decrease_clean_stat_case.decrease_clean_stat_case(high_low_stat[0], high_low_stat[1], target_stat)
	

	var movement_percent : float = 0.0

	## case two ##
	# when this is active we always give max returns from breeding

	if GLShareholderOfferState.offer_2_active :
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 2')
		
		# we return 3 not because it is getting farther from org. pos but for the trickery
		return 3
	##############



	if high_low_stat[0] != 0:
		movement_percent = abs(
			finale_value - high_low_stat[0]
		) / high_low_stat[0]
	
	# phase 1
	if movement_percent <= 0.2: 
		return 1

	# phase 2
	elif movement_percent <= 0.5 :
		return 2

	# phase 3
	else :
		return 3

###################################################

func _display_arrow(stat_type : String, arrow_type : String, arrow_phase :int) :
	
	match stat_type :
		'strength' :
			if arrow_type == 'up' :
				strength_arrow_up.visible = true
				strength_arrow_up._set_breeding_arrow_phase(arrow_phase)
			elif arrow_type == 'down' :
				strength_arrow_down.visible = true
				strength_arrow_down._set_breeding_arrow_phase(arrow_phase)

		'intelligence' :
			if arrow_type == 'up' :
				intelligence_arrow_up.visible = true
				intelligence_arrow_up._set_breeding_arrow_phase(arrow_phase)
			elif arrow_type == 'down' :
				intelligence_arrow_down.visible = true
				intelligence_arrow_down._set_breeding_arrow_phase(arrow_phase)

		'community' :
			if arrow_type == 'up' :
				community_arrow_up.visible = true
				community_arrow_up._set_breeding_arrow_phase(arrow_phase)
			elif arrow_type == 'down' :
				community_arrow_down.visible = true
				community_arrow_down._set_breeding_arrow_phase(arrow_phase)
		
##############################
	
func _reset_symbols() : 
	strength_arrow_up.visible = false
	strength_arrow_down.visible = false
	
	intelligence_arrow_up.visible = false
	intelligence_arrow_down.visible = false
	
	community_arrow_up.visible = false
	community_arrow_down.visible = false
	
