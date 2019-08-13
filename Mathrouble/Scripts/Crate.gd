extends Area2D

export (Texture) var health_crate_sprite
export (Texture) var ammo_crate_sprite

onready var crate_sprite = $crate_sprite

const CRATES = ["health", "ammo"]
var choosen_crate = "health"

func _ready():
	_choose_crate()

func _choose_crate():
	randomize()
	choosen_crate = CRATES[randi() % CRATES.size()]
	match choosen_crate:
		"health":
			_prepare_crate(health_crate_sprite, "health_crate")
		"ammo":
			_prepare_crate(ammo_crate_sprite, "ammo_crate")

func _prepare_crate(sprite, group_name):
	crate_sprite.texture = sprite
	self.add_to_group(group_name)