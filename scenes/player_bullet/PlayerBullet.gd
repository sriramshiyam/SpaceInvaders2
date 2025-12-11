extends Area2D

class_name PlayerBullet


const SPEED: float = 600

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.y < -100:
		queue_free()


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
