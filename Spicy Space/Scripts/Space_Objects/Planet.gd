extends Area2D

signal explore_planet(result)

export(bool) var livable_control = false

func _physics_process(delta):
	_rotate(delta)

func _rotate(delta):
	var rot_speed = rad2deg(0.0005)
	self.rotation = (rotation + rot_speed * -1 * delta)

func _on_Planet_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("explore_planet", livable_control)
