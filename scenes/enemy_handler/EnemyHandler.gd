extends Node2D

class_name EnemyHandler

@export var spawn_point: Marker2D
@export var left_max_pos: Marker2D
@export var right_max_pos: Marker2D

@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var move_down_timer: Timer = $Timers/MoveDownTimer
@onready var enemies: Node2D = $Enemies
@onready var enemy_destroy_sound: AudioStreamPlayer = $EnemyDestroySound
@onready var create_bullet_timer: Timer = $Timers/CreateBulletTimer
@onready var enemy_laser_sound: AudioStreamPlayer = $EnemyLaserSound

const ENEMY: PackedScene = preload("res://scenes/enemy/Enemy.tscn")

const ENEMIES_IN_ROW: int = 11
const TOTAL_ENEMIES: int = ENEMIES_IN_ROW * 5
const ENEMY_SPAWN_TIME: float = 0.05
const MOVE_DOWN_TIME: float = 0.5
const MAX_ENEMY_TYPE: int = 3

var start_game: bool = false
var game_over: bool = false

var offset_vec: Vector2
var all_enemies_spawned: bool
var enemies_spawned: int
var total_enemies_spawned: int
var spawn_vec: Vector2
var enemy_type: int
var x_speed: int
var y_speed: int
var move_dir: int
var move_down: bool
var mystery_ship_created: bool
var mystery_ship_destroyed: bool

func _ready() -> void:
	offset_vec = Vector2(48, 50)
	load_var()

func _enter_tree() -> void:
	SignalBus.enemy_destroyed.connect(play_enemy_destroy_sound)
	SignalBus.mystery_ship_destroyed.connect(on_mystery_ship_destroyed)
	
func _physics_process(delta: float) -> void:
	if start_game:
		start_enemy_spawn()
		mark_enemies()
		move_enemies(delta)
		spawn_mystery_ship()
	elif game_over:
		victory_dance()

func start_enemy_spawn() -> void:
	if all_enemies_spawned and len(enemies.get_children()) == 0\
		and mystery_ship_destroyed:
		load_var()
		spawn_timer.start(ENEMY_SPAWN_TIME)

func spawn_mystery_ship() -> void:
	if all_enemies_spawned and len(enemies.get_children()) <= 20\
		and not mystery_ship_created:
			SignalBus.emit_spawn_mystery_ship()
			mystery_ship_created = true

func load_var() -> void:
	all_enemies_spawned = false
	enemies_spawned = 0
	total_enemies_spawned = 0
	spawn_vec = spawn_point.position
	enemy_type = 0
	x_speed = 100
	y_speed = 80
	move_dir = 1
	move_down = false
	mystery_ship_created = false
	mystery_ship_destroyed = false
	
func move_enemies(delta: float) -> void:
	if not all_enemies_spawned:
		return

	for enemy: Enemy in enemies.get_children():
		var pos: Vector2 = enemy.position

		if move_down:
			pos.y += y_speed * delta
		else:
			pos.x += x_speed * move_dir * delta
			move_down = (enemy.right_most and pos.x > right_max_pos.position.x) or\
						(enemy.left_most and pos.x < left_max_pos.position.x)
			if move_down:
				y_speed += ((TOTAL_ENEMIES - len(enemies.get_children())) / 3) + Hud.waves - 1
				move_down = true
				move_dir *= -1
				move_down_timer.start(MOVE_DOWN_TIME)

		enemy.position = pos

		if enemy.rigid_body_2d.global_position.y > Shields.SHIELD_POS_Y:
			SignalBus.emit_game_over()
			return

func mark_enemies() -> void:
	if len(enemies.get_children()) == 0:
		return

	var max_right: float = 0
	var max_left: float = 2000
	var left_most_enemy: Enemy
	var right_most_enemy: Enemy

	for enemy: Enemy in enemies.get_children():
		enemy.left_most = false
		enemy.right_most = false

		if enemy.position.x > max_right:
			max_right = enemy.position.x
			right_most_enemy = enemy
		if enemy.position.x < max_left:
			max_left = enemy.position.x
			left_most_enemy = enemy
	
	left_most_enemy.left_most = true
	right_most_enemy.right_most = true

func spawn_enemy() -> void:
	var enemy: Enemy = ENEMY.instantiate()
	enemies_spawned += 1
	total_enemies_spawned += 1

	spawn_vec.x += offset_vec.x
	enemy.position = spawn_vec
	
	enemies.add_child(enemy)
	enemy.sprite_2d.texture = ImageManager.get_enemy_texture(enemy_type)
	enemy.type = enemy_type

	if enemies_spawned == ENEMIES_IN_ROW:
		enemy_type += 1
		if enemy_type > MAX_ENEMY_TYPE:
			enemy_type = 0
		enemies_spawned = 0
		spawn_vec.y += offset_vec.y
		spawn_vec.x = spawn_point.position.x

	if total_enemies_spawned == TOTAL_ENEMIES:
		all_enemies_spawned = true
		create_bullet_timer.start(3)
		Hud.waves += 1
		return
	else:
		spawn_timer.start(ENEMY_SPAWN_TIME)

func shoot_bullet() -> void:
	if not all_enemies_spawned or game_over:
		return

	var length: int = len(enemies.get_children())
	if length == 0:
		return

	var num: int = randi_range(1, 4 + Hud.waves)
	var list: Array[int] = []

	while list.size() != num:
		var rand_index: int = randi_range(0, length - 1)
		list.append(rand_index)

	for i: int in list:
		var enemy: Enemy = enemies.get_children()[i]
		SignalBus.emit_create_enemy_bullet(enemy.rigid_body_2d.global_position)
	enemy_laser_sound.play()

	create_bullet_timer.start(randi_range(2, 4))

func start() -> void:
	for enemy: Enemy in enemies.get_children():
		enemy.queue_free()
	start_game = true
	game_over = false
	load_var()
	spawn_timer.start(EnemyHandler.ENEMY_SPAWN_TIME)

func victory_dance() -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_move_down_timer_timeout() -> void:
	x_speed += ((TOTAL_ENEMIES - len(enemies.get_children())) / 3) + Hud.waves - 1
	move_down = false
	
func play_enemy_destroy_sound() -> void:
	enemy_destroy_sound.play()

func _on_create_bullet_timer_timeout() -> void:
	shoot_bullet()

func on_mystery_ship_destroyed() -> void:
	mystery_ship_destroyed = true
