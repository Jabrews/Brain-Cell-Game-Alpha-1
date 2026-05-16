extends Node

@onready var cell_container_parent : CharacterBody3D = $"../.."
@onready var dying_sound : AudioStreamPlayer3D = $DyingSound

func state_start() : 
	
	# stop processing/movement if needed
	cell_container_parent.set_physics_process(false)
	cell_container_parent.set_process(false)
	
	dying_sound.play()
	
	var tween = create_tween()
	
	# store original position
	var original_pos = cell_container_parent.position
	
	# run effects together
	tween.set_parallel(true)
	
	# shrimk
	tween.tween_property(
		cell_container_parent,
		"scale",
		Vector3.ONE * 0.001,
		1.0	
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	
	# shaking effect
	for i in range(8):
		
		var random_offset = Vector3(
			randf_range(-0.08, 0.08),
			randf_range(-0.08, 0.08),
			randf_range(-0.08, 0.08)
		)
		
		tween.tween_property(
			cell_container_parent,
			"position",
			original_pos + random_offset,
			0.03
		)
	
	
	# reset position
	tween.tween_property(
		cell_container_parent,
		"position",
		original_pos,
		0.03
	)
	
	await tween.finished
	
	
	cell_container_parent.queue_free()
