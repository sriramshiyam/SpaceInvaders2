extends AnimatableBody2D

class_name Player

@export var left_max_pos: Marker2D
@export var right_max_pos: Marker2D

@onready var bullet_sound: AudioStreamPlayer = $BulletSound

var jump_spring: Dictionary
var shoot_timer: float = 0

const SHOOT_SPEED: float = 1000
const SPEED: float = 400
const SHOOT_WAIT_TIME: float = 0.17

func _ready() -> void:
	sync_to_physics = false
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
	move_and_collide(Vector2())

func handle_spring() -> void:
	var x = global_position.y - jump_spring.rest_length
	jump_spring.force = -jump_spring.k * x;
	jump_spring.velocity += jump_spring.force
	global_position.y += jump_spring.velocity
	jump_spring.velocity *= jump_spring.damping
