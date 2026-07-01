extends Node

@onready var switch_screen : Node = $SwitchScreen

@onready var reward_label : Label = $Reward/EnergyReward

func _load_reward(reward : int) :
	reward_label.text = str(reward)
