extends Bullet

class_name EnemyBullet

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not body.attacked:
		Hud.lives = Hud.lives.substr(2)
		if Hud.lives.length() == 0:
			SignalBus.emit_game_over()
		else:
			body.attack_effect()
		queue_free()
	elif body is Shield:
		body.reduce_life()
		queue_free()
