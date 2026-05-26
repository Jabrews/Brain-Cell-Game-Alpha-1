extends Node

var player_refrence : CharacterBody3D

var player_health = 4
var player_invincible : bool = false


signal increment_player_health(damange_amount : int)
signal player_health_changed()

var player_holding_axe_mount : bool = false
signal toggle_player_picked_up_axe_mount(toggleValue : bool)
