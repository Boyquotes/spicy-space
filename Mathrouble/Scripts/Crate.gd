extends Area2D

export (Texture) var health_crate_sprite
export (Texture) var shield_crate_sprite

onready var crate_sprite = $crate_sprite

const CRATES = ["health", "shield"]

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
		"shield":
			_prepare_crate(shield_crate_sprite, "shield_crate")

func _prepare_crate(sprite, group_name):
	crate_sprite.texture = sprite
	self.add_to_group(group_name)
	#crate color
	if group_name == "health_crate":
		self.modulate = Color(0.5, 0.9, 0.35) #green
	elif group_name == "shield_crate":
		self.modulate = Color(0.35, 0.9, 0.85) #blue

func remove_crate():
	call_deferred("free")

func _on_Crate_area_entered(area):
	if area.is_in_group("enemyship"):
		remove_crate()

func _on_Crate_body_entered(body):
	if body.is_in_group("asteroid"):
		remove_crate()
