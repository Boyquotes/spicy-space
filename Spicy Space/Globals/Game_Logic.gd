extends Node2D

export(Array, PackedScene) var planets
export(Array, PackedScene) var roadmaps

var planet_list = []
var roadmap_list = []
var choosen_planet
var choosen_roadmap

func _ready():
	_prepare_planets()
	_prepare_roadmaps()
#	_select_a_planet()
#	_select_a_roadmap()

func _prepare_planets():
	for planet in planets:
		var ins_planet = planet.instance()
		planet_list.append(ins_planet)
	#make one of the planets livable
	_make_a_planet_livable()

func _prepare_roadmaps():
	for roadmap in roadmaps:
		var ins_roadmap = roadmap.instance()
		roadmap_list.append(ins_roadmap)

func _make_a_planet_livable():
	randomize()
	var random_planet = planet_list[randi()% planet_list.size()]
	random_planet.livable_control = true

func select_a_planet():
	randomize()
	var selected_planet = planet_list[randi()% planet_list.size()]
	planet_list.erase(selected_planet)
	return selected_planet

func select_a_roadmap():
	randomize()
	var selected_roadmap = roadmap_list[randi()% roadmap_list.size()]
	return selected_roadmap


