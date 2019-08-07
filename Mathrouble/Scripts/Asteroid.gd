extends KinematicBody2D

export var bounce = 1.1

onready var puff_effect = $puff_particle

var vel = Vector2()
var rot_speed

func _ready():
	randomize()
	set_physics_process(true)
	vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2 * PI))
	rot_speed = rand_range(-1.5, 1.5)

func _physics_process(delta):
	self.rotation =  self.rotation + rot_speed * delta
	var collide = move_and_collide(delta * vel)
	if collide:
		vel += collide.normal * (collide.collider_velocity.length() * bounce)
		# puff effect
#		puff_effect.global_position = collide.position
#		puff_effect.emitting = true

func _on_asteroid_vis_viewport_exited(viewport):
	call_deferred("free")
