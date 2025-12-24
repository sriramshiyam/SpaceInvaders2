extends Node2D

const SPEED: float = 75

func _enter_tree() -> void:
	SignalBus.player_moved.connect(move_stars)

func move_stars(right: bool, delta: float) -> void:
	for node: ColorRect in get_children():
		node.position.x += (-SPEED if right else SPEED) * delta
