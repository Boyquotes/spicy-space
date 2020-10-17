extends Node2D

#screen shake
onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship_w_robots = $Spaceship_w_Robots
onready var spaceship = $Spaceship_w_Robots/SpaceShip
#HUD
onready var hud = $HUD
#Upgrade HUD
onready var upg_hud = $HUD/Upgrade_HUD

func _ready():
	_signal_connect("spaceship")
	_signal_connect("upgrade system")

func _signal_connect(which_obj):
	if which_obj == "spaceship":
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#warning signal
		spaceship.connect("warning", hud, "warning")
		#screen shake signal connect
		spaceship.connect("ss_damage", self, "screen_shake")
		#when spaceship grabbed mine signal connect
		spaceship.connect("mine_grabbed", self, "mine_system")
	if which_obj == "upgrade system":
		#signal to update mine after spend or collect it
		upg_hud.connect("mine_spend", self, "mine_system")
		#signal to upgrade ship part
		upg_hud.connect("upgraded", self, "upgrade_system")

func mine_system(con):
	if con == "collect":
		var collected_mine = int(rand_range(Global.wave * 2, Global.wave * 3))
#		print(collected_mine)
		Global.mine_counter += collected_mine
	if con == "spend":
		pass
	if con == "game_over":
		Global.mine_counter -= int(Global.mine_counter * 0.3)
	#save and show mine value
	UserDataManager.save_userdata("mine", Global.mine_counter)
	hud.show_mine_value()

func upgrade_system(part):
	if part == "ship_dur":
		spaceship_w_robots.ins_hr.reload_robot(part)
	if part == "shield":
		spaceship_w_robots.ins_sr.reload_robot(part)
	if part == "shoot_rate":
		spaceship.reload_spaceship()

func screen_shake(which_pitfall):
	screen_shake.start(0.2, 15, 16, 1)

func game_over():
	Global.fail_counter += 1
	mine_system("game_over")
	hud.game_over()
