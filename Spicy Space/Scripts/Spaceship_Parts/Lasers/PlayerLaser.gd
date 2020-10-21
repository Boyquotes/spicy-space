extends "res://Scripts/Spaceship_Parts/Lasers/Laser.gd"

func _ready():
	_prepare_laser()

func _prepare_laser():
	laser_damage = UserDataManager.load_userdata("laser_damage")

func _on_Laser_body_entered(body):
	if body.is_in_group("asteroid"): # when asteroid shooted
		queue_free()
		Global.score += 1
#		print("laser damage: " + str(laser_damage))
		body.ast_dur -= laser_damage #reduce asteroid's durability
		if body.ast_dur <= 0:
			body.explode(vel.normalized())
