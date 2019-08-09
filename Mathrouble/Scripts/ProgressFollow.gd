extends Area2D

const MAX_SPEED = 65
const MAX_FORCE = 1

var target
var direction = Vector2()
var velocity = Vector2()
var following_obj

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if self.global_position == target:
		pass
	else:
		_move(delta)

func _move(delta):
		velocity = steer(target)
		move_local_x(velocity.x * delta)
		move_local_y(velocity.y * delta)
		target = following_obj.global_position

func steer(target):
	var desired_velocity = (target - self.position).normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)