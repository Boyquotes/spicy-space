extends Area2D

signal entered_to_hole

var target_planet
var roadmap

func _on_Black_Hole_area_entered(area):
	if area.name == "SpaceShip":
		GameLogic.choosen_planet = target_planet
		GameLogic.choosen_roadmap = roadmap
		emit_signal("entered_to_hole")
		print("spaceship entered to balck hole")
