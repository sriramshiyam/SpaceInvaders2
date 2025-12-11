extends StaticBody2D

class_name Shield

var life: float = 10

func reduce_life() -> void:
	life -= 1
	if life == 0:
		queue_free()
