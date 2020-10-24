extends Node

signal mode_completed(which_mode)

var spaceship_w_robots
var spaceship
#var hud

func setting_for_mode_difficulty(difficulty):
	if difficulty != null:
		print("mode difficulty:", str(Global.difficulty.keys()[difficulty]))
	pass
