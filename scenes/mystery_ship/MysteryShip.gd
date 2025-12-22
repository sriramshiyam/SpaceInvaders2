extends Area2D

class_name MysteryShip

var rotate_spring: Dictionary
var left_max_pos: Marker2D
var right_max_pos: Marker2D
var moving_left: bool = true
const SPEED: float = 200

func _ready() -> void:
	rotation = -PI / 6
	rotate_spring = Util.get_spring(0, 0.008, 0)
	
func _enter_tree() -> void:
	SignalBus.start_game.connect(queue_free)

func _physics_process(delta: float) -> void:
	handle_rotate_spring()
	handle_movement(delta)

func handle_rotate_spring():
	rotation = Util.calculate_spring(rotation, rotate_spring)

func handle_movement(delta: float) -> void:
	if moving_left:
		position.x -= SPEED * delta
		if position.x < left_max_pos.position.x:
			moving_left = false
	else:
		position.x += SPEED * delta
		if position.x > right_max_pos.position.x:
			moving_left = true
