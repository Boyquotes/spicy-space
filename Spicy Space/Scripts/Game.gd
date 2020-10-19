extends Node2D

#screen shake
onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship_w_robots = $Spaceship_w_Robots
onready var spaceship = $Spaceship_w_Robots/SpaceShip
#HUD
onready var hud = $HUD

func _ready():
	_signal_connect()

func _signal_connect():
	# game over signal connect
	spaceship.connect("game_over", self, "game_over")
	#warning signal
	spaceship.connect("warning", hud, "warning")
	#screen shake signal connect
	spaceship.connect("ss_damage", self, "screen_shake")
	#when spaceship grabbed mine signal connect
	spaceship.connect("mine_grabbed", self, "mine_system")

func mine_system(con):
	if con == "collect":
#		var collected_mine = int(rand_range(Global.wave * 2, Global.wave * 3))
#		print(collected_mine)
		Global.mine_counter += 1
	if con == "spend":
		pass
	#save and show mine value
	UserDataManager.save_userdata("mine", Global.mine_counter)
	hud.show_mine_value()

func screen_shake(which_pitfall):
	screen_shake.start(0.2, 15, 16, 1)

func game_over():
	Global.fail_counter += 1
	hud.game_over()
