extends "res://Scripts/Robot.gd"

signal sr_deactivated(situation)

var damage_value = 0

#func _ready():
#	self.modulate = Color(1, 1, 1)
	
func damage_happened(which_pitfall):
	if which_pitfall == "asteroid":
		damage_value = 10
		_get_damage(damage_value)
	elif which_pitfall == "laser":
		damage_value = 5
		_get_damage(damage_value)

func _get_damage(damage_value):
	if self.value > 0:
		self.value -= damage_value
#		print("health: " + str(value))
	if self.value <= 0:
		emit_signal("sr_deactivated", true) #activate health robot
		robot_color("red") #change robots color as red