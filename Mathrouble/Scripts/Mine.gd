extends Area2D

func _on_Mine_area_entered(area):
	if area.is_in_group("enemyship"):
		remove_mine()

func _on_Mine_body_entered(body):
	print(body.name)
	if body.is_in_group("asteroid"):
		remove_mine()

func remove_mine():
	call_deferred("free")
