extends Bullet

class_name PlayerBullet

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Enemy":
		var enemy: Enemy = body.get_parent()
		SignalBus.emit_enemy_destroyed()
		SignalBus.emit_create_explosion(body.global_position)
		SignalBus.emit_create_broken_enemy(body.global_position, enemy.type)
		SignalBus.emit_create_combo(body.global_position)
		enemy.queue_free()
		queue_free()
	elif body is Shield:
		body.reduce_life()
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is MysteryShip:
		area.queue_free()
		queue_free()
		SignalBus.emit_enemy_destroyed()
		SignalBus.emit_mystery_ship_destroyed()
		SignalBus.emit_create_broken_mystery_ship(area.global_position)
		SignalBus.emit_create_explosion(area.global_position)
		SignalBus.emit_create_combo(area.global_position)
