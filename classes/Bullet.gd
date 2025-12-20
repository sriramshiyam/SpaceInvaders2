extends Area2D

class_name Bullet

@export var SPEED: float
@export var move_up: bool 

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta
	if (move_up and position.y < -100) or position.y > (get_viewport_rect().size.y + 200):
		queue_free()
