extends  Node


# components
@onready var parent_cell_container := $".."
@onready var age_lifespan_sound : AudioStreamPlayer3D = $"../AgeLifespan"
@onready var life_span_label : Label = $"../StatDisplay/StatMesh/SubViewport/BasicRecieverScreen/StatDisplay/CellLifeSpan"
@onready var stat_display_mesh : MeshInstance3D = $"../StatDisplay/StatMesh"

var last_lifespan : int = 0
var designated_brain_cell : BrainCell

var life_span_warning_tween : Tween


func _ready() -> void:
	designated_brain_cell = parent_cell_container.designated_brain_cell
	last_lifespan = designated_brain_cell.life_span
	
	GLCellManagerBus.connect('cell_changed', _handle_cell_changed)


func _handle_cell_changed(changed_brain_cell : BrainCell) -> void:
	
	if designated_brain_cell.name == changed_brain_cell.name :
	
		if last_lifespan != changed_brain_cell.life_span :
		
			# update cached value immediately
			last_lifespan = changed_brain_cell.life_span

			# play effect if lifespan changed and cell isn't dead
			if changed_brain_cell.life_span > 0:
				play_life_span_changed_effect()
				shake_life_span_label()

func play_life_span_changed_effect() -> void:

	var original_scale = parent_cell_container.scale

	age_lifespan_sound.play()

	var scale_tween : Tween = create_tween()

	for i in 6:

		scale_tween.tween_property(
			parent_cell_container,
			"scale",
			original_scale + Vector3(0.2, 0.2, 0.2),
			0.1
		)

		scale_tween.tween_property(
			parent_cell_container,
			"scale",
			original_scale,
			0.1
		)


func shake_life_span_label() :

	if life_span_warning_tween:
		life_span_warning_tween.kill()

	var original_pos = life_span_label.position
	var original_scale = life_span_label.scale

	life_span_warning_tween = create_tween()
	life_span_warning_tween.set_loops()

	life_span_warning_tween.parallel().tween_property(
		life_span_label,
		"position:x",
		original_pos.x + 4,
		0.05
	)

	life_span_warning_tween.parallel().tween_property(
		life_span_label,
		"scale",
		original_scale * 1.3,
		0.2
	)

	life_span_warning_tween.parallel().tween_property(
		life_span_label,
		"position:x",
		original_pos.x - 4,
		0.1
	)

	life_span_warning_tween.parallel().tween_property(
		life_span_label,
		"position:x",
		original_pos.x,
		0.05
	)

	life_span_warning_tween.parallel().tween_property(
		life_span_label,
		"scale",
		original_scale,
		0.2
	)

	await get_tree().create_timer(6.0).timeout

	if life_span_warning_tween:
		life_span_warning_tween.kill()
		life_span_warning_tween = null

	life_span_label.position = original_pos
	life_span_label.scale = original_scale
