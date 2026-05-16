extends Area3D 

func _ready() -> void:
	connect('body_entered', _handle_body_entered_item_trash_can_area)

func _handle_body_entered_item_trash_can_area(body : Node) :
	if body.is_in_group('usable_item') :
		GLUseableItemManagerBus.emit_signal('useable_item_deleted', body.designated_useable_item_obj.item_id )
		body.queue_free()
