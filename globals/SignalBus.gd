extends Node

signal create_player_bullet(pos: Vector2)
signal create_explosion(pos: Vector2)
signal create_combo(pos: Vector2)
signal create_broken_enemy(pos: Vector2, type: int)
signal create_broken_shield(pos: Vector2)
signal create_enemy_bullet(pos: Vector2)
signal enemy_destroyed
signal spawn_mystery_ship()
signal mystery_ship_destroyed()
signal create_broken_mystery_ship(pos: Vector2)

func emit_create_player_bullet(pos: Vector2) -> void:
	create_player_bullet.emit(pos)

func emit_create_explosion(pos: Vector2) -> void:
	create_explosion.emit(pos)

func emit_create_combo(pos: Vector2) -> void:
	create_combo.emit(pos)

func emit_create_broken_enemy(pos: Vector2, type: int) -> void:
	create_broken_enemy.emit(pos, type)

func emit_create_broken_shield(pos: Vector2) -> void:
	create_broken_shield.emit(pos)

func emit_create_enemy_bullet(pos: Vector2) -> void:
	create_enemy_bullet.emit(pos)

func emit_enemy_destroyed() -> void:
	enemy_destroyed.emit()

func emit_spawn_mystery_ship() -> void:
	spawn_mystery_ship.emit()

func emit_mystery_ship_destroyed() -> void:
	mystery_ship_destroyed.emit()

func emit_create_broken_mystery_ship(pos: Vector2) -> void:
	create_broken_mystery_ship.emit(pos)

signal start_game()
signal game_over()

func emit_start_game() -> void:
	start_game.emit()

func emit_game_over() -> void:
	game_over.emit()
