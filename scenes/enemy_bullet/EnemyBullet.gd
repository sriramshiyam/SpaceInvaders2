extends Bullet

class_name EnemyBullet

func _ready() -> void:
	SPEED = -300
	upper_cond = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
	elif body is Shield:
		body.reduce_life()
		queue_free()
