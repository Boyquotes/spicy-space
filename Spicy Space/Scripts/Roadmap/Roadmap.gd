extends Node2D

export var scroll_limit = 500

var camera
var roadmap_camera_pos = Vector2.ZERO

func _on_Roadmap_visibility_changed():
	camera.position = roadmap_camera_pos

func _on_Roadmap_hide():
		roadmap_camera_pos = camera.get_camera_position()
		camera.position = Vector2.ZERO



