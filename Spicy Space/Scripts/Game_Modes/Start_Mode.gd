extends "res://Scripts/Game_Modes/Mode.gd"

onready var black_holes = $Black_Holes

func _ready():
	_prepare_black_holes()

func _prepare_black_holes():
	for black_hole in black_holes.get_children():
		black_hole.target_planet = GameLogic.select_a_planet()
		black_hole.roadmap = GameLogic.select_a_roadmap()
		black_hole.connect("entered_to_hole", self, "start_mode_completed")

func start_mode_completed():
	emit_signal("mode_completed", Global.game_mode.start)
