extends Node

signal create_player_bullet(pos: Vector2)
signal create_explosion(pos: Vector2)
signal create_combo(pos: Vector2)
signal create_broken_enemy(pos: Vector2, type: int)
signal enemy_destroyed

func emit_create_player_bullet(pos: Vector2) -> void:
	create_player_bullet.emit(pos)

func emit_create_explosion(pos: Vector2) -> void:
	create_explosion.emit(pos)

func emit_create_combo(pos: Vector2) -> void:
	create_combo.emit(pos)

func emit_create_broken_enemy(pos: Vector2, type: int) -> void:
	create_broken_enemy.emit(pos, type)

func emit_enemy_destroyed() -> void:
	enemy_destroyed.emit()
