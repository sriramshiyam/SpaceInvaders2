extends StaticBody2D

class_name Shield

var life: float = 10

func reduce_life() -> void:
	life -= 1
	if life == 0:
		SignalBus.emit_enemy_destroyed()
		SignalBus.emit_create_explosion(global_position)
		SignalBus.emit_create_broken_shield(global_position)
		queue_free()
