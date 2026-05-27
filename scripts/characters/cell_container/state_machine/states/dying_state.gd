extends Node

# components
@onready var cell_container_parent : CharacterBody3D = $"../.."
@onready var dying_sound : AudioStreamPlayer3D = $DyingSound
@onready var flesh_slug_instance : PackedScene = preload("res://scenes/characters/flesh_bugs/flesh_slug/flesh_slug.tscn")
@onready var flesh_bug_parent_node : Node = $"../../../../FleshBugParentNode"

var already_dying := false


func state_start() :

	if already_dying:
		return

	already_dying = true
	
	# stop processing/movement if needed
	cell_container_parent.set_physics_process(false)
	cell_container_parent.set_process(false)
	
	dying_sound.play()
	
	var tween = create_tween()
	
	# store original position
	var original_pos = cell_container_parent.position
	
	# run effects together
	tween.set_parallel(true)
	
	# shrink
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

	create_flesh_slug()

	cell_container_parent.queue_free()


func create_flesh_slug():
	
	
	# prevent spawining flesh slug if dying on breeder
	if not cell_container_parent.spawn_flesh_bug_on_death  :
		return
	
	
	var flesh_slug = flesh_slug_instance.instantiate()

	flesh_bug_parent_node.add_child(flesh_slug)

	flesh_slug.global_position = cell_container_parent.global_position
