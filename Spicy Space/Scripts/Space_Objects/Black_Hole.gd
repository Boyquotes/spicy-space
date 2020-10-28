extends Area2D

signal entered_to_hole

var target_planet
var roadmap

func _physics_process(delta):
	_rotate(delta)

func _rotate(delta):
	var rot_speed = rad2deg(0.01)
	self.rotation = (rotation + rot_speed * 1 * delta)

func _on_Black_Hole_area_entered(area):
	if area.name == "SpaceShip":
		GameLogic.choosen_planet = target_planet
		GameLogic.choosen_roadmap = roadmap
		emit_signal("entered_to_hole")
		print("spaceship entered to black hole")
