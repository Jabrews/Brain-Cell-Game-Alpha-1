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
	bar.connect('mouse_entered', _handle_mouse_entered)
	bar.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if stat_hovered_over :
		if Input.is_action_just_pressed('attack') :
			
			get_parent()._handle_pop_up_stat_selected(stat_type)
			
	
func _handle_mouse_entered() :
	if stat_disabled :	
		return
	
	highlight.visible = true
	stat_hovered_over = true

func _handle_mouse_exited() :
	if stat_disabled :	
		return
	
	highlight.visible = false
	stat_hovered_over = false 

func handle_display_stat_info(stat : BrainCellStat) :
	if stat:
		var max_val = IVCellCreator.max_stat_value
		
		# hide disabled stat		
		if stat.enabled == false :
			stat_disabled = true
			visible = false
		
		# hide
		hide_stat.visible = stat.hidden
		
		# defect
		defect_bar.max_value = max_val
		defect_bar.value = stat.defect
		
		# clean stat bar
		var target_stat_value : float = 0.0
		var target_cell = GLCellManagerBus.target_cell_refrence
		
		if target_cell != null:
			match stat.type:
				"strength":
					target_stat_value = target_cell.strength.value
				"intelligence":
					target_stat_value = target_cell.intelligence.value
				"community":
					target_stat_value = target_cell.community.value
		
		var stat_norm = float(stat.value) / max_val
		var target_stat_norm = float(target_stat_value) / max_val
		
		bar.material.set_shader_parameter("prisoner_value", stat_norm)
		bar.material.set_shader_parameter("target_value", target_stat_norm)
	else:
		reset_stat()

func reset_stat() :
		hide_stat.visible = false
		defect_bar.value = 0
		bar.material.set_shader_parameter("prisoner_value", 0)
		bar.material.set_shader_parameter("target_value", 0)
		
		stat_disabled = false 
		visible = true 
	
	
	
