extends Node2D

export (bool) var reset_userdata = false
export(PackedScene) var start_mode
export(PackedScene) var repairshop_mode
export(Array, PackedScene) var game_modes
export(PackedScene) var planet_mode

#Game
onready var game = $Game
#roadmap
onready var roadmap = $Roadmap

var ins_game_mode

func _ready():
	#reset all userdata
	if reset_userdata == true:
		UserDataManager.reset_userdata()
	#reset score after every new start
	Global.score = 0
	#start game
	prepare_game_mode(Global.game_mode.start, null)

func prepare_game_mode(mode, difficulty):
	game.spaceship.centered_position()
	roadmap.visible = false
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
	ins_game_mode.connect("mode_completed", self, "go_back_to_roadmap")
	ins_game_mode.setting_for_mode_difficulty(difficulty)
	add_child(ins_game_mode)

func go_back_to_roadmap(completed_mode):
	if completed_mode == Global.game_mode.start:
		_prepare_roadmap()
	else:
		yield(get_tree().create_timer(3), "timeout")
	game.visible = false
	roadmap.visible = true
	ins_game_mode.call_deferred("free")

func _prepare_roadmap():
	var selected_roadmap = GameLogic.choosen_roadmap
	roadmap.add_child(selected_roadmap)
