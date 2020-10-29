extends Node2D

export var scroll_limit = 500

onready var stages = $Roadmap_System/Stages

var camera
var roadmap_camera_pos = Vector2.ZERO
var current_stage = 1

func _on_Roadmap_visibility_changed():
	camera.position = roadmap_camera_pos
	_find_current_stage()

func _on_Roadmap_hide():
		roadmap_camera_pos = camera.get_camera_position()
		camera.position = Vector2.ZERO

func _find_current_stage():
	for stage in stages.get_children():
		if stage.stage_completed:
			current_stage = stage.stage_no
	_complete_lower_stages(current_stage)

func _complete_lower_stages(current):
	for stage in stages.get_children():
		if stage.stage_no < current:
			stage.stage_completed = true
			stage.disable_other_roads()

