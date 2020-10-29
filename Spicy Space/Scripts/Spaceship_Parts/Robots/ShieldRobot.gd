extends "res://Scripts/Spaceship_Parts/Robots/Robot.gd"

signal sr_deactivated(hr_situation)

func _ready():
	reload_robot("shield")

func damage_happened(value):
		damage_value = int(value)
		_get_damage(damage_value)

func _get_damage(damage_value):
	if self.value > 0:
		self.value -= damage_value
#		print("health: " + str(value))
	if self.value <= 0:
		emit_signal("sr_deactivated", true) #activate health robot
		robot_color("red") #change robots color as red
