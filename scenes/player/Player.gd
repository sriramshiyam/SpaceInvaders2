extends AnimatableBody2D

class_name Player

@export var left_max_pos: Marker2D
@export var right_max_pos: Marker2D
@export var start_pos: Marker2D

@onready var bullet_sound: AudioStreamPlayer = $BulletSound
@onready var sprite_2d: Sprite2D = $Sprite2D

var jump_spring: Dictionary
var shoot_timer: float = 0
var attacked: bool = false

const SHOOT_SPEED: float = 1000
const SPEED: float = 400
const SHOOT_WAIT_TIME: float = 0.2

func _ready() -> void:
	sync_to_physics = false
	global_position = start_pos.global_position
	create_jump_spring()

func create_jump_spring() -> void:
	jump_spring = Util.get_spring(0.6, 0.1, global_position.y)

func _physics_process(delta: float) -> void:
	if shoot_timer > 0:
		shoot_timer -= delta
	handle_attack(delta)
	handle_movement(delta)
	handle_spring()

func handle_attack(delta: float) -> void:
	if Input.is_action_pressed("shoot") and shoot_timer <= 0:
		shoot_timer = SHOOT_WAIT_TIME
		global_position.y += SHOOT_SPEED * delta
		var pos: Vector2 = global_position
		pos.y -= 31
		SignalBus.emit_create_player_bullet(pos)
		bullet_sound.play()
		
func handle_movement(delta: float) -> void:
	if Input.is_action_pressed("right"):
		position.x += SPEED * delta
	elif Input.is_action_pressed("left"):
		position.x -= SPEED * delta

	position.x = clampf(position.x, left_max_pos.position.x, right_max_pos.position.x)
	
	if position.x != left_max_pos.position.x and position.x != right_max_pos.position.x and\
		(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
			SignalBus.emit_player_moved(Input.is_action_pressed("right"), delta)
				
	move_and_collide(Vector2.ZERO)

func handle_spring() -> void:
	global_position.y = Util.calculate_spring(global_position.y, jump_spring)

func die() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func start() -> void:
	global_position = start_pos.global_position
	show()
	process_mode = Node.PROCESS_MODE_INHERIT

func attack_effect() -> void:
	attacked = true
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("red_alpha", true)
	await get_tree().create_timer(3.0).timeout
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("red_alpha", false)
	attacked = false
