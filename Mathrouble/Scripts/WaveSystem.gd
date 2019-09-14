extends Node

var wave_counter = 0

func inc_wave():
	wave_counter += 1
	Global.wave = wave_counter