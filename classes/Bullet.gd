extends Area2D

class_name Bullet

var SPEED: float
var upper_cond: bool 

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if (upper_cond and position.y < -100) or position.y > (get_viewport_rect().size.y + 200):
		queue_free()
