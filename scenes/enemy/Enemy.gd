extends AnimatableBody2D

class_name Enemy

@onready var sprite_2d: Sprite2D = $RigidBody2D/Sprite2D
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D

var type: int

func _ready() -> void:
	rigid_body_2d.name = "Enemy"

var right_most: bool
var left_most: bool
