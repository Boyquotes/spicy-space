extends Area2D

signal explore_planet(result)

export(bool) var livable_control = false

func _on_Planet_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("explore_planet", livable_control)
