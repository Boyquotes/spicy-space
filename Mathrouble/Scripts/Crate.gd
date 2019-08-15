extends Area2D

export (Texture) var health_crate_sprite
export (Texture) var ammo_crate_sprite

onready var crate_sprite = $crate_sprite

const CRATES = ["health", "ammo"]

var choosen_crate = "health"
var rot_dir = 1

func _ready():
	set_physics_process(true)
	_choose_crate()
	_rot_dir() # choose rotate direction

func _physics_process(delta):
	_rotate(delta)

func _rotate(delta):
	var rot_speed = rad2deg(0.01)
	self.rotation = (rotation + rot_speed * rot_dir * delta)

func _rot_dir():
	rot_dir
	var rot_dir_chance = rand_range(0, 100)
	rot_dir = 1 if rot_dir_chance < 50 else -1

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

func remove_crate():
	call_deferred("free")