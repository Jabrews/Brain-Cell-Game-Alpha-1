extends Node3D

@onready var s_fail : AudioStreamPlayer3D = $Fail
@onready var s_success : AudioStreamPlayer3D = $Success
@onready var s_confirm : AudioStreamPlayer3D = $Confirm


func play_fail() :
	s_fail.play()

func play_success() :
	s_success.play()

func play_confirm(): 
	s_confirm.play()
