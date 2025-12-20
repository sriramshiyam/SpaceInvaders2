extends Bullet

class_name EnemyBullet

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Hud.lives = Hud.lives.substr(2)
		queue_free()
	elif body is Shield:
		body.reduce_life()
		queue_free()
