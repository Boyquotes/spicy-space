extends "res://Scripts/Spaceship_Parts/Lasers/Laser.gd"

func _ready():
	_prepare_laser()

func _prepare_laser():
	laser_damage *= Global.wave;
