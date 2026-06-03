extends Node


func _handle_check_disabled(key : String, cell_left : BrainCell, cell_right : BrainCell) :

	# get highest lowest stat
		match key : 
			'str'  :
				if not cell_left.strength.enabled or not cell_right.strength.enabled :
					return true
				else : 
					return false
			'int' : 
				if not cell_left.intelligence.enabled or not cell_right.intelligence.enabled :
					return true
				else : 
					return false
			'com' :
				if not cell_left.community.enabled or not cell_right.community.enabled :
					return true
				else : 
					return false
			_:		
				push_error('no key value found for disabled_stat_updater')
