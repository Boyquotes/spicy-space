extends Node2D

onready var spaceship = $SpaceShip
onready var enemies = $enemies

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	for e in enemies.get_children().size():
		enemies.get_child(e).target_obj = spaceship
#		enemies.get_child(e).target = spaceship.global_position