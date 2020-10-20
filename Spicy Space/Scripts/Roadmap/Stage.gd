extends Node2D

export(int) var stage_no = 0
export(bool) var stage_completed = false

func _ready():
	_check_stages()

func _check_stages():
	for road in get_children():
		if road.mode_completed:
			stage_completed = true
			_disable_other_roads()

func _disable_other_roads():
	for road in get_children():
		if !road.mode_completed:
			road.road("skipped")

func _on_Stage_visibility_changed():
	_check_stages()
