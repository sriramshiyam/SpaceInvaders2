extends Node2D

class_name BrokenParticle

var impulse_applied: bool = false
@export var min_force: float
@export var max_force: float

func _enter_tree() -> void:
	SignalBus.start_game.connect(queue_free)

func _process(_delta: float) -> void:
	if len(get_children()) == 0:
		queue_free()
		return

	for broken_particle: RigidBody2D in get_children():
		if broken_particle.position.y > (get_viewport_rect().size.y + 200):
			broken_particle.queue_free()
			
func _physics_process(_delta: float) -> void:
	if not impulse_applied:
		impulse_applied = true
		var IMPULSE_MULT_X: float = randf_range(min_force, max_force)
		var IMPULSE_MULT_Y: float = randf_range(min_force, max_force)

		for broken_particle: RigidBody2D in get_children():
			var impulse_vec: Vector2 = Vector2(randf_range(-1, 1) * IMPULSE_MULT_X,
											   randf_range(-1, -0.2) * IMPULSE_MULT_Y)
			broken_particle.apply_central_impulse(impulse_vec)
