extends Node
#
func handle_offer_5(_cell_constructors : Array[CellConstructor]):
	print('offer 5 not set up yet')
	return
#
	#if GLShareholderOfferState.offer_5_active:
		#if GLShareholderOfferState.display_stat_offer_active_debug_messages:
			#print_debug("offer 5")
#
	#var total_stat_to_hide_quanity : int = get_constructor_total_stat_to_hide_quanity(cell_constructors)
#
	## cut total in half
	#@warning_ignore("integer_division")
	#total_stat_to_hide_quanity = int(total_stat_to_hide_quanity / 2)
#
	#var curr_quanity : int = 0
	#var reached_limit : bool = false
#
	## loop through constructors in order
	#for constructor : CellConstructor in cell_constructors:
#
		#var new_stats_to_hide : Array[StatsToHide] = []
#
		#for stat_to_hide : StatsToHide in constructor.stats_to_hide:
#
			#if reached_limit:
				#print("erasing stat to hide : ", stat_to_hide)
				#continue
#
			#print("keeping stat to hide : ", stat_to_hide)
#
			#new_stats_to_hide.append(stat_to_hide)
			#curr_quanity += stat_to_hide.quantity
#
			#if curr_quanity >= total_stat_to_hide_quanity:
				#reached_limit = true
#
		#constructor.stats_to_hide = new_stats_to_hide
#
	#return cell_constructors
#
#
#func get_constructor_total_stat_to_hide_quanity(cell_constructors : Array[CellConstructor]):
#
	#var total_stat_to_hide_quanity : int = 0
#
	#for constructor : CellConstructor in cell_constructors:
		#for stat_to_hide : StatsToHide in constructor.stats_to_hide:
			#total_stat_to_hide_quanity += stat_to_hide.quantity
#
	#return total_stat_to_hide_quanity
