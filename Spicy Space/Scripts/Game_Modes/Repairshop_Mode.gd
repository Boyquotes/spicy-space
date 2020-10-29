extends "res://Scripts/Game_Modes/Mode.gd"

signal send_robot_info(object)

#Repairshop HUD
onready var repairshop_hud = $Repairshop_HUD
#Repair HUD
onready var repair_hud = $Repairshop_HUD/Repairshop_Tabs/Repair/Repair_HUD
#Upgrade HUD
onready var upg_hud = $Repairshop_HUD/Repairshop_Tabs/Upgrade/Upgrade_HUD

func _ready():
	_signal_connect()
	emit_signal("send_robot_info")

func _signal_connect():
	#signal to prepare mock spaceship
	self.connect("send_robot_info", repairshop_hud.spaceship_mock, "prepare_mock", [spaceship_w_robots])
	#signal to close repairshop
	repairshop_hud.connect("closed", self, "close_repairshop")
	#signal to update mine value after spend it
	upg_hud.connect("mine_spend", get_parent().get_node("Game"), "mine_system")
	#signal ro repair robots
	repair_hud.connect("repaired", self, "repair_system")
	#signal to upgrade ship part
	upg_hud.connect("upgraded", self, "upgrade_system")

func upgrade_system(part):
	if part == "durability":
		spaceship_w_robots.ins_hr.reload_robot(part)
	if part == "shield":
		spaceship_w_robots.ins_sr.reload_robot(part)
	if part == "shoot_rate":
		spaceship.reload_spaceship()
	emit_signal("send_robot_info")

func repair_system(part):
	if part == "durability":
		spaceship_w_robots.ins_hr.repair_robot(part)
	if part == "shield":
		spaceship_w_robots.ins_sr.repair_robot(part)
	emit_signal("send_robot_info")

func close_repairshop():
	emit_signal("mode_completed", Global.game_mode.repairshop)
