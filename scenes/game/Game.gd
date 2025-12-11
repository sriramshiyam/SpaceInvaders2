extends Node2D

@onready var player_bullets: Node2D = $PlayerBullets
@onready var explosions: Node2D = $Explosions
@onready var player: Player = $Player
@onready var broken_enemies: Node2D = $BrokenEnemies

const PLAYER_BULLET: PackedScene = preload("res://scenes/player_bullet/PlayerBullet.tscn")
const EXPLOSION: PackedScene = preload("res://scenes/explosion/Explosion.tscn")
const BROKEN_ENEMIES: Array[PackedScene] = [preload("res://scenes/broken_enemy/broken_enemy1/BrokenEnemy1.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy2/BrokenEnemy2.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy3/BrokenEnemy3.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy4/BrokenEnemy4.tscn")]
func _enter_tree() -> void:
	SignalBus.create_player_bullet.connect(create_player_bullet)
	SignalBus.create_explosion.connect(create_explosion)
	SignalBus.create_broken_enemy.connect(create_broken_enemy)

func create_player_bullet(pos: Vector2) -> void:
	var bullet: PlayerBullet = PLAYER_BULLET.instantiate()
	bullet.global_position = pos
	player_bullets.add_child(bullet)

func create_explosion(pos: Vector2) -> void:
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.global_position = pos
	explosions.add_child(explosion)
	explosion.emit_particles()

func create_broken_enemy(pos: Vector2, type: int) -> void:
	var broken_enemy: BrokenEnemy = BROKEN_ENEMIES[type].instantiate()
	broken_enemy.global_position = pos
	broken_enemies.call_deferred("add_child", broken_enemy)
