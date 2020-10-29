extends Node2D

export (bool) var reset_userdata = false
export(PackedScene) var start_mode
export(PackedScene) var repairshop_mode
export(Array, PackedScene) var game_modes
export(PackedScene) var planet_mode

#Camera
onready var camera = $Camera2D
onready var screen_shake = $Camera2D/ScreenShake
#Game
onready var game = $Game
#roadmap
onready var roadmap_manager = $Roadmap_Manager

var ins_game_mode

func _ready():
	#reset all userdata
	if reset_userdata == true:
		UserDataManager.reset_userdata()
	#reset score after every new start
	Global.score = 0
	#prepare game logic
	GameLogic.prepare_game_logic()
	#start game
	prepare_game_mode(Global.game_mode.start, null)
	#signal
	_signal_connect()

func _signal_connect():
	#signal connect to activate roadmap when clicked roadmap button
	game.spaceship_w_robots.cockpit_hud.connect("activate_roadmap", roadmap_manager, "open_roadmap")

func prepare_game_mode(mode, difficulty):
	game.spaceship.centered_position()
	roadmap_manager.visible = false
	game.visible = true
	if mode == Global.game_mode.start:
		ins_game_mode = start_mode.instance()
	elif mode == Global.game_mode.repairshop:
		ins_game_mode = repairshop_mode.instance()
	elif mode == Global.game_mode.meteor_shower:
		ins_game_mode = game_modes[0].instance()
	elif mode == Global.game_mode.dog_fight:
		ins_game_mode = game_modes[1].instance()
	elif mode == Global.game_mode.random:
		ins_game_mode = game_modes[randi()% game_modes.size()].instance()
	elif mode == Global.game_mode.planet:
		ins_game_mode = planet_mode.instance()
	ins_game_mode.spaceship_w_robots = game.spaceship_w_robots
	ins_game_mode.spaceship = game.spaceship
	ins_game_mode.connect("mode_completed", roadmap_manager, "roadmap_handler")
	ins_game_mode.setting_for_mode_difficulty(difficulty)
	add_child(ins_game_mode)


