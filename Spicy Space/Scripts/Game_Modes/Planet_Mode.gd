extends "res://Scripts/Game_Modes/Mode.gd"

onready var planet_pos = $planet_pos
onready var planet_hud = $Planet_HUD
onready var result_hud = $Result_HUD

var planet

func _ready():
	_prepare_planet()
	yield(get_tree().create_timer(6), "timeout")
	planet_hud.visible = false

func _prepare_planet():
	planet = GameLogic.choosen_planet
	planet.position = planet_pos.position
	planet.connect("explore_planet", self, "show_result")
	add_child(planet)

func show_result(livable):
	SceneManager.show_transition()
	yield(get_tree().create_timer(0.8), "timeout")
	result_hud.visible = true
	if livable:
		print("This planet is livable :D")
		result_hud.prepare_result("livable")
	else:
		print("This planet isn't livable :(")
		result_hud.prepare_result("not livable")
