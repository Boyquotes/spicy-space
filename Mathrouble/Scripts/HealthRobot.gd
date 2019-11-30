extends "res://Scripts/Robot.gd"

signal ss_explode #spaceship explode

var damage_value = 0
var hr_on = false #health robot off

func hr_situation(situation):
	hr_on = situation #health robot on or off according to shield robot

func damage_happened(which_pitfall):
#	print("hr situation: " + str(hr_on))
	if hr_on:
		if which_pitfall == "asteroid":
			damage_value = 100
			_get_damage(damage_value)
		elif which_pitfall == "laser":
			damage_value = 40
			_get_damage(damage_value)

func _get_damage(damage_value):
	if self.value > 0:
		self.value -= damage_value
#		print("health: " + str(value))
	if self.value <= 0:
		emit_signal("ss_explode")