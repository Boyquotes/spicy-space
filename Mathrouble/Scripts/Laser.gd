extends Area2D

export var speed = 1000

var vel = Vector2()

func _ready():
	set_physics_process(true)

func start_at(dir, pos, v):
	self.rotation = dir
	self.position = pos
	vel = v + Vector2(speed, 0).rotated(dir + (-PI/2))

func _physics_process(delta):
	self.position = self.position + vel * delta

func _on_lifetime_timeout():
	queue_free()

func _on_Laser_body_entered(body):
	if body.is_in_group("asteroid"): # when asteroid shooted
		queue_free()
		body.explode()
