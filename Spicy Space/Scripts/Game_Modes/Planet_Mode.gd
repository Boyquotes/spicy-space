extends "res://Scripts/Game_Modes/Mode.gd"

onready var planet_pos = $planet_pos

func _ready():
	_prepare_planet()

func _prepare_planet():
	var planet = GameLogic.choosen_planet
	planet.position = planet_pos.position
	add_child(planet)
	if planet.livable_control:
		print("This planet is livable :D")
	else:
		print("This planet isn't livable :(")
