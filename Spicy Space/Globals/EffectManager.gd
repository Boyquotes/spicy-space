extends Node

export (PackedScene) var explosion

func explosion_effect(pos):
	var ins_explosion = explosion.instance()
	ins_explosion.position = pos
	add_child(ins_explosion)
	ins_explosion.anim.play("explosion")
	yield(get_tree().create_timer(ins_explosion.anim.current_animation_length), "timeout")
	ins_explosion.queue_free()
