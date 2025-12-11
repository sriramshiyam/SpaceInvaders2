extends Node2D

@export var spawn_point: Marker2D
@export var left_max_pos: Marker2D
@export var right_max_pos: Marker2D

@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var move_down_timer: Timer = $Timers/MoveDownTimer
@onready var enemies: Node2D = $Enemies
@onready var enemy_destroy_sound: AudioStreamPlayer = $EnemyDestroySound

const ENEMY: PackedScene = preload("res://scenes/enemy/Enemy.tscn")
const ENEMIES_IN_ROW: int = 11
const TOTAL_ENEMIES: int = ENEMIES_IN_ROW * 5
const ENEMY_SPAWN_TIME: float = 0.05
const MOVE_DOWN_TIME: float = 0.5
const MAX_ENEMY_TYPE: int = 3

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

func _ready() -> void:
	offset_vec = Vector2(48, 50)
	load_var()
	spawn_timer.start(ENEMY_SPAWN_TIME)

func _enter_tree() -> void:
	SignalBus.enemy_destroyed.connect(play_enemy_destroy_sound)
	
func _physics_process(delta: float) -> void:
	if all_enemies_spawned and len(enemies.get_children()) == 0:
		load_var()
		spawn_timer.start(ENEMY_SPAWN_TIME)

	mark_enemies()
	move_enemies(delta)

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
				y_speed += (TOTAL_ENEMIES - len(enemies.get_children())) / 3
				move_down = true
				move_dir *= -1
				move_down_timer.start(MOVE_DOWN_TIME)

		enemy.position = pos

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
		return
	else:
		spawn_timer.start(ENEMY_SPAWN_TIME)


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_move_down_timer_timeout() -> void:
	x_speed += (TOTAL_ENEMIES - len(enemies.get_children())) / 3
	move_down = false
	
func play_enemy_destroy_sound() -> void:
	enemy_destroy_sound.play()
