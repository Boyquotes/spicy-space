extends "res://Scripts/Robot.gd"

signal out_of_ammo(condition)

func laser_shooted():
	if self.value > 0:
		self.value -= 1
		emit_signal("out_of_ammo", false)
	else:
		emit_signal("out_of_ammo", true)