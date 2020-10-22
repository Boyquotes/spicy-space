extends "res://Scripts/Game_Modes/Mode.gd"

#Upgrade HUD
onready var upg_hud = $Upgrade_HUD

func _ready():
	_signal_connect()

func _signal_connect():
	#signal to update mine value after spend it
	upg_hud.connect("mine_spend", get_parent().get_node("Game"), "mine_system")
	#signal to upgrade ship part
	upg_hud.connect("upgraded", self, "upgrade_system")
	#signal to close repairshop scene
	upg_hud.connect("closed", self, "close_repairshop")

func upgrade_system(part):
	if part == "ship_dur":
		spaceship_w_robots.ins_hr.reload_robot(part)
	if part == "shield":
		spaceship_w_robots.ins_sr.reload_robot(part)
	if part == "shoot_rate":
		spaceship.reload_spaceship()

func close_repairshop():
	emit_signal("mode_completed", "repairshop")
