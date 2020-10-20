extends Node2D

export (bool) var reset_userdata = false
export(PackedScene) var start_mode
export(PackedScene) var repairshop_mode
export(Array, PackedScene) var game_modes
export(PackedScene) var planet_mode

#Game
onready var game = $Game
#roadmap
onready var roadmaps = $Roadmaps

var ins_game_mode

func _ready():
	#reset highscore
	if reset_userdata == true:
		UserDataManager.reset_userdata()
	#reset score after every new start
	Global.score = 0
	#choose a random roadmap
	_prepare_roadmap()

func _prepare_roadmap():
	randomize()
	var random_roadmap = roadmaps.get_child(randi()% roadmaps.get_child_count())
	random_roadmap.visible = true

func prepare_game_mode(mode):
	roadmaps.visible = false
	game.visible = true
	if mode == "start":
		ins_game_mode = start_mode.instance()
	elif mode == "repairshop":
		ins_game_mode = repairshop_mode.instance()
	elif mode == "meteor shower":
		ins_game_mode = game_modes[0].instance()
	elif mode == "dog fight":
		ins_game_mode = game_modes[1].instance()
	elif mode == "random":
		ins_game_mode = game_modes[randi()% game_modes.size()].instance()
	elif mode == "planet":
		ins_game_mode = planet_mode.instance()
	ins_game_mode.spaceship_w_robots = game.spaceship_w_robots
	ins_game_mode.spaceship = game.spaceship
	ins_game_mode.hud = game.hud
	ins_game_mode.connect("mode_completed", self, "go_back_to_roadmap")
	add_child(ins_game_mode)

func go_back_to_roadmap():
	game.visible = false
	roadmaps.visible = true
	ins_game_mode.call_deferred("free")

