extends Area2D

func remove_mine():
	call_deferred("free")

func _on_Mine_area_entered(area):
	if area.is_in_group("enemyship"):
		remove_mine()

func _on_Mine_body_entered(body):
	if body.is_in_group("asteroid"):
		remove_mine()
