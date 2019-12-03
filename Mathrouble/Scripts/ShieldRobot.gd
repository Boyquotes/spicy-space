extends "res://Scripts/Robot.gd"

signal sr_deactivated(hr_situation)

var damage_value = 0

func _ready():
	self.max_value = UserDataManager.load_userdata("shield")
	self.value = self.max_value

func damage_happened(which_pitfall):
	if which_pitfall == "asteroid":
		damage_value = 25
		_get_damage(damage_value)
	elif which_pitfall == "laser":
		damage_value = 20
		_get_damage(damage_value)

func _get_damage(damage_value):
	if self.value > 0:
		self.value -= damage_value
#		print("health: " + str(value))
	if self.value <= 0:
		emit_signal("sr_deactivated", true) #activate health robot
		robot_color("red") #change robots color as red