extends Node2D

onready var anim = $sprite/anim

func _ready():
	if self.name == "Engine":
		anim.play("engine")
	if self.name == "Shield":
		anim.play("shield")