extends Node2D

const ROADMAP_LIMIT = 500

var camera
var roadmap_camera_pos = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion and event.button_mask > 0:
		var rel_y = event.relative.y
		var camera_pos = camera.position
		camera_pos.y -= rel_y
		if camera_pos.y < -ROADMAP_LIMIT:
			camera_pos.y = -ROADMAP_LIMIT
		elif camera_pos.y > 0:
			camera_pos.y = 0
		camera.position = camera_pos

func _on_Roadmap1_visibility_changed():
	camera.position = roadmap_camera_pos

func _on_Roadmap1_hide():
		roadmap_camera_pos = camera.get_camera_position()
#		print(roadmap_camera_pos)
		camera.position = Vector2.ZERO



