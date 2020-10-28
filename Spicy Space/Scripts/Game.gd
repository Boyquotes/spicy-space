extends Node2D

#screen shake
#onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship_w_robots = $Spaceship_w_Robots
onready var spaceship = $Spaceship_w_Robots/SpaceShip
#HUD
onready var game_hud = $Game_HUD

func _ready():
	_signal_connect()

func _signal_connect():
	# game over signal connect
	spaceship.connect("game_over", self, "game_over")
	#screen shake signal connect
	spaceship.connect("ss_damage", self, "screen_shake")
	#when spaceship grabbed mine signal connect
	spaceship.connect("mine_grabbed", self, "mine_system")

func mine_system(con):
	if con == "collect":
		Global.mine += 1
	if con == "spend":
		pass

func screen_shake(which_pitfall):
	SFXManager.hit.play()
	get_parent().screen_shake.start(0.2, 15, 16, 1)

func game_over():
	Global.fail_counter += 1
	game_hud.game_over()
