extends Node2D

@onready var player_bullets: Node2D = $PlayerBullets
@onready var explosions: Node2D = $Explosions
@onready var player: Player = $Player
@onready var broken_enemies: Node2D = $BrokenEnemies
@onready var broken_shields: Node2D = $BrokenShields
@onready var enemy_bullets: Node2D = $EnemyBullets
@onready var left_max_pos: Marker2D = $Markers/LeftMaxPos
@onready var right_max_pos: Marker2D = $Markers/RightMaxPos
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var shields: Shields = $Shields
@onready var music: AudioStreamPlayer = $Music
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound

const PLAYER_BULLET: PackedScene = preload("res://scenes/player_bullet/PlayerBullet.tscn")
const EXPLOSION: PackedScene = preload("res://scenes/explosion/Explosion.tscn")
const BROKEN_ENEMIES: Array[PackedScene] = [preload("res://scenes/broken_enemy/broken_enemy1/BrokenEnemy1.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy2/BrokenEnemy2.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy3/BrokenEnemy3.tscn"),
											preload("res://scenes/broken_enemy/broken_enemy4/BrokenEnemy4.tscn")]
const BROKEN_SHIELD: PackedScene = preload("res://scenes/broken_shield/BrokenShield.tscn")
const ENEMY_BULLET: PackedScene = preload("res://scenes/enemy_bullet/EnemyBullet.tscn")
const MYSTERY_SHIP: PackedScene = preload("res://scenes/mystery_ship/MysteryShip.tscn")
const BROKEN_MYSTERY_SHIP: PackedScene = preload("res://scenes/broken_mystery_ship/BrokenMysteryShip.tscn")

func _enter_tree() -> void:
	SignalBus.start_game.connect(start_game)
	SignalBus.game_over.connect(game_over)
	SignalBus.create_player_bullet.connect(create_player_bullet)
	SignalBus.create_explosion.connect(create_explosion)
	SignalBus.create_broken_enemy.connect(create_broken_enemy)
	SignalBus.create_broken_shield.connect(create_broken_shield)
	SignalBus.create_enemy_bullet.connect(create_enemy_bullet)
	SignalBus.spawn_mystery_ship.connect(spawn_mystery_ship)
	SignalBus.create_broken_mystery_ship.connect(create_broken_mystery_ship)

func start_game() -> void:
	if not enemy_handler.start_game:
		music.play()
		remove_particles()
		Hud.reset()
		player.start()
		enemy_handler.start()
		shields.create_shields()
		shields.show()

func game_over() -> void:
	music.stop()
	game_over_sound.play()
	SignalBus.emit_enemy_destroyed()
	SignalBus.emit_create_explosion(player.global_position)
	enemy_handler.start_game = false
	enemy_handler.game_over = true
	player.die()

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
	var broken_enemy: BrokenParticle = BROKEN_ENEMIES[type].instantiate()
	broken_enemy.global_position = pos
	broken_enemies.call_deferred("add_child", broken_enemy)

func create_broken_shield(pos: Vector2) -> void:
	var broken_shield: BrokenParticle = BROKEN_SHIELD.instantiate()
	broken_shield.global_position = pos
	broken_shields.call_deferred("add_child", broken_shield)

func create_enemy_bullet(pos: Vector2) -> void:
	var enemy_bullet: EnemyBullet = ENEMY_BULLET.instantiate()
	enemy_bullet.global_position = pos
	enemy_bullets.add_child(enemy_bullet)

func spawn_mystery_ship() -> void:
	var mystery_ship: MysteryShip = MYSTERY_SHIP.instantiate()
	mystery_ship.left_max_pos = left_max_pos
	mystery_ship.right_max_pos = right_max_pos
	mystery_ship.global_position.x = right_max_pos.position.x
	mystery_ship.global_position.y = 50
	add_child(mystery_ship)

func create_broken_mystery_ship(pos: Vector2) -> void:
	var broken_mystery_ship: BrokenParticle = BROKEN_MYSTERY_SHIP.instantiate()
	broken_mystery_ship.global_position = pos
	broken_enemies.call_deferred("add_child", broken_mystery_ship)

func remove_particles() -> void:
	var nodes: Array[Node] = [shields, broken_enemies, broken_shields, enemy_bullets, player_bullets, explosions]
	for parent_node: Node in nodes:
		for node: Node in parent_node.get_children():
			node.queue_free()
