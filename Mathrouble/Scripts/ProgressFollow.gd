extends Area2D

export (int, "SEEK", "FLEE") var mode = 0

const MAX_SPEED = 65
const MAX_FORCE = 1
const DETECT_RADIUS = 100
const FOV = 80

#onready var target = self.position

var target
var angle = 0
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
		_fov_movement(delta)

func _move(delta):
		velocity = steer(target)
		move_local_x(velocity.x * delta)
		move_local_y(velocity.y * delta)
		target = following_obj.global_position

func steer(target):
	var desired_velocity = (target - self.position).normalized() * MAX_SPEED
	if mode == 0:
		pass
	elif mode == 1:
		desired_velocity = -desired_velocity
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func _fov_movement(delta):
	var pos = self.position
	if mode == 0: #seek
		direction = (pos - following_obj.global_position).normalized()
		angle = 180 + rad2deg(direction.angle())
	elif mode == 1: #flee
#		direction = (ins_spaceship.global_position - pos).normalized()
#		angle = 180 + rad2deg(direction.angle())
		pass

	var detect_count = 0
	for node in get_tree().get_nodes_in_group('detectable'):
		if pos.distance_to(node.position) < DETECT_RADIUS:
			var angle_to_node = rad2deg(direction.angle_to((following_obj.global_position - node.position).normalized()))
			if abs(angle_to_node) < FOV/2:
				detect_count += 1