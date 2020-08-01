extends "res://Scripts/Lasers/Laser.gd"

func _ready():
	_prepare_laser()

func _prepare_laser():
	laser_damage *= Global.wave;