extends "res://Scripts/Spaceship_Parts/Robots/Robot.gd"

signal ss_explode #spaceship explode

var damage_value = 0
var hr_on = false #health robot off

func _ready():
	reload_robot("ship_dur")

func hr_situation(situation):
	hr_on = situation #health robot on or off according to shield robot

func damage_happened(value):
#	print("hr situation: " + str(hr_on))
	if hr_on:
		damage_value = int(value)
		_get_damage(damage_value)

func _get_damage(damage_value):
	if self.value > 0:
		self.value -= damage_value
#		print("health: " + str(value))
	if self.value <= 0:
		emit_signal("ss_explode")
