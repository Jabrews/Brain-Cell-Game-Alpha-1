extends Control 

@export var stat_type : String

var stat_hovered_over : bool = false
var stat_disabled : bool = false

# components
@onready var highlight : Sprite2D = $Highlight
@onready var bar : TextureRect = $Bar
@onready var defect_bar : TextureProgressBar = $DefectBar
@onready var hide_stat : Sprite2D = $Hide


func _ready() -> void:
	bar.mouse_entered.connect(_handle_mouse_entered)
	bar.mouse_exited.connect(_handle_mouse_exited)
	
	bar.material = bar.material.duplicate()	


func _process(_delta: float) -> void:
	if stat_disabled:
		return
	
	if stat_hovered_over:
		if Input.is_action_just_pressed("attack"):
			get_parent()._handle_pop_up_stat_selected(stat_type)


func _handle_mouse_entered() -> void:
	if stat_disabled:	
		return
	
	highlight.visible = true
	stat_hovered_over = true


func _handle_mouse_exited() -> void:
	highlight.visible = false
	stat_hovered_over = false 


func handle_display_stat_info(stat : BrainCellStat) -> void:
	if stat == null:
		reset_stat()
		return
	
	var max_val : float = IVCellCreator.max_stat_value
	
	# disabled stat
	if stat.enabled == false:
		stat_disabled = true
		stat_hovered_over = false
		highlight.visible = false
		visible = false
		return
	
	stat_disabled = false
	visible = true
	
	# hidden icon
	hide_stat.visible = stat.hidden
	
	# defect bar
	defect_bar.max_value = max_val
	defect_bar.value = stat.defect
	
	# prisoner stat value
	var prisoner_value : float = stat.value / max_val
	
	
	# target stat value
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	var target_stat_value : float = 0.0
		
	match stat_type:
		"strength":
			target_stat_value = target_cell.strength.value
		"intelligence":
			target_stat_value = target_cell.intelligence.value
		"community":
			target_stat_value = target_cell.community.value
		_:
			push_error("Invalid stat_type: " + stat_type)
		
	var target_value = target_stat_value / max_val
	
	print('pris : ', prisoner_value)
	print('target: ', target_value)
	
	
	bar.material.set_shader_parameter("prisoner_value", prisoner_value)
	bar.material.set_shader_parameter("target_value", target_value)


func reset_stat() -> void:
	hide_stat.visible = false
	
	defect_bar.value = 0
	
	bar.material.set_shader_parameter("prisoner_value", 0.0)
	bar.material.set_shader_parameter("target_value", 0.0)
	
	stat_disabled = false
	stat_hovered_over = false
	
	highlight.visible = false
	visible = true
