extends Node

var player_is_holding = false

# connected
signal start_hold(hold_max_duriation : int, hold_duration_increment : int , hold_id : String)
signal player_interupted_hold()

# emited
signal end_hold(hold_id: String, is_success: bool )
