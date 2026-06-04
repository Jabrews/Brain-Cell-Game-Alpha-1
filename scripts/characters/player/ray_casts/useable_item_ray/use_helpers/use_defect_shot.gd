extends Node
 
func use(collider : Node3D, held_useable_item_obj : UseableItemObject) :
	
		GLUsableItemBus.emit_signal(
			'use_defect_shot',
			collider.designated_brain_cell,
			held_useable_item_obj
		)

		# increment shot energy downward
		held_useable_item_obj.item_energy -= 1

		GLPlayerLocalSoundsBus.emit_signal('sound_shot_used')
		if held_useable_item_obj.item_energy <= 0:

			GLUsableItemBus.emit_signal(
				'useable_item_used',
				true,
				held_useable_item_obj
			)
			
			return true
		
		else:
			
			GLUsableItemBus.emit_signal(
				'useable_item_used',
				false,
				held_useable_item_obj
			)
			
			
			return false
