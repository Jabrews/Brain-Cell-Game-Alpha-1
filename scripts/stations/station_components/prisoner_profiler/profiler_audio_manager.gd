extends Node

@onready var s_cycle_stat : AudioStreamPlayer3D = $CycleStat
@onready var s_feedback_sound : AudioStreamPlayer3D = $FeedbackSound
@onready var s_increment: AudioStreamPlayer3D = $Increment
@onready var s_lock_shake : AudioStreamPlayer3D = $LockShake
@onready var s_on_off : AudioStreamPlayer3D = $OnOffClick
@onready var s_generate : AudioStreamPlayer3D = $Generate
@onready var s_spare_enter : AudioStreamPlayer3D = $SpareEnter
@onready var s_spare_exit : AudioStreamPlayer3D = $SpareExit

func play_cycle_stat() :
	s_cycle_stat.play()

func play_feedback_sound() :
	s_feedback_sound.play()

func play_increment_sound() :
	s_increment.play()

func play_on_off_sound() :
	s_on_off.play()

func play_generate() :
	s_generate.play()

func play_lock_shake() :
	s_increment.stop()
	s_lock_shake.stop()
	s_lock_shake.play()

func play_spare_enter() :
	s_spare_exit.stop()
	s_spare_enter.play()

func play_spare_exit() :
	s_spare_enter.stop()
	s_spare_exit.play()
