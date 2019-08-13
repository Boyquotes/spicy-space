extends "res://Scripts/Robot.gd"

signal out_of_ammo(condition)

func laser_shooted():
	if self.value > 0: #there are ammo
		self.value -= 1
		emit_signal("out_of_ammo", false)
	else: #ammo over
		emit_signal("out_of_ammo", true)