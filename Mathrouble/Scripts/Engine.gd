extends Node2D

onready var engine_anim = $engine_sprite/engine_anim

func _ready():
	engine_anim.play("engine")