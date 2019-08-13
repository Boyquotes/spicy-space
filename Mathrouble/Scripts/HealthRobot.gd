extends "res://Scripts/Robot.gd"

signal ss_explode #spaceship explode

func damage_happened():
	if self.value > 0:
		self.value -= 10
	if self.value <= 0:
		emit_signal("ss_explode")