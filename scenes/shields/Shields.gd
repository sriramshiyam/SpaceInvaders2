extends Node2D

class_name Shields

@export var start_point: Marker2D
@export var end_point: Marker2D

var x_pos: float
var x_offset: float
const SHIELD_SCALE: float = 3.5
const SHIELD_POS_Y: float = 540

const SHIELD: PackedScene = preload("res://scenes/shield/Shield.tscn")

func calculate_shield_var() -> void:
	x_offset = (end_point.position.x - start_point.position.x) / 7

func create_shields() -> void:
	calculate_shield_var()
	x_pos = 0
	var shield: Shield

	shield = SHIELD.instantiate()
	shield.position.y = SHIELD_POS_Y
	shield.position.x = start_point.position.x
	add_child(shield)

	for i in range(6):
		x_pos += x_offset
		shield = SHIELD.instantiate()
		shield.position.y = SHIELD_POS_Y
		shield.position.x = start_point.position.x + x_pos
		add_child(shield)

	shield = SHIELD.instantiate()
	shield.position.y = SHIELD_POS_Y
	shield.position.x = end_point.position.x
	add_child(shield)
