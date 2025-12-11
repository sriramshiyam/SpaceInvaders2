extends Node

const ENEMIES: Array[Texture2D] = [preload("res://assets/sprite/enemy1.png"),
								   preload("res://assets/sprite/enemy2.png"),
								   preload("res://assets/sprite/enemy3.png"),
								   preload("res://assets/sprite/enemy4.png")]
const ENEMY_LASER: Texture2D = preload("res://assets/sprite/enemy_laser.png")
const PLAYER_LASER: Texture2D = preload("res://assets/sprite/player_laser.png")

func get_enemy_texture(i: int) -> Texture2D:
	return ENEMIES[i]
		
