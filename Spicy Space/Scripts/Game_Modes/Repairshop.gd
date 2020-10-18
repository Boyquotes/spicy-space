extends "res://Scripts/Game_Modes/Game_Mode.gd"

#Upgrade HUD
onready var upg_hud = $Upgrade_HUD

func _ready():
	_signal_connect()

func _signal_connect():
	#signal to update mine after spend or collect it
	upg_hud.connect("mine_spend", self, "mine_system")
	#signal to upgrade ship part
	upg_hud.connect("upgraded", self, "upgrade_system")
	#when spaceship grabbed mine signal connect
	spaceship.connect("mine_grabbed", self, "mine_system")

func mine_system(con):
	if con == "collect":
		var collected_mine = int(rand_range(Global.wave * 2, Global.wave * 3))
#		print(collected_mine)
		Global.mine_counter += collected_mine
	if con == "spend":
		pass
#	if con == "game_over":
#		Global.mine_counter -= int(Global.mine_counter * 0.3)
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

func _on_Close_btn_pressed():
	emit_signal("mode_completed")
