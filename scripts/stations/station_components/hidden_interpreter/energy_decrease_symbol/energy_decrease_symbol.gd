extends MeshInstance3D


# componnets
@onready var decrease_label : Label3D = $DecreaseLabel
@onready var delete_delay_timer : Timer = $DeleteDelay

func _ready() -> void:
	delete_delay_timer.connect('timeout', _handle_delete_timeout)
	delete_delay_timer.start()

func _process(delta: float) -> void:
	self.position.y += 0.5 * delta

func _load(decrease_energy_amount : int) :
	decrease_label.text = '-' + str(decrease_energy_amount)
	GLGameManagerBus.curr_energy -= decrease_energy_amount
	GLGameManagerBus.emit_signal('energy_changed')
	
	
func _handle_delete_timeout() :
	queue_free()



	
	
	
	
