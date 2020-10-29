extends Camera2D

var y_limit

#scroll
func _unhandled_input(event):
	if event is InputEventMouseMotion and event.button_mask > 0:
		var rel_y = event.relative.y
		var camera_pos = self.position
		camera_pos.y -= rel_y
		if camera_pos.y < -y_limit:
			camera_pos.y = -y_limit
		elif camera_pos.y > 0:
			camera_pos.y = 0
		self.position = camera_pos
