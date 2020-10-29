extends Node2D

onready var hr = $HealthRobot
onready var sr = $ShieldRobot

func prepare_mock(spaceship_w_robots):
	print(spaceship_w_robots.ins_hr.value)
	print(spaceship_w_robots.ins_sr.value)
	hr.value = spaceship_w_robots.ins_hr.value
	sr.value = spaceship_w_robots.ins_sr.value

func get_robot_info(robot):
	var value
	if robot == "durability":
		value = $HealthRobot.value
	elif robot == "shield":
		value = $ShieldRobot.value
	return value




