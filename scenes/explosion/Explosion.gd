extends Node2D

class_name Explosion

@onready var smokes: CPUParticles2D = $Smokes
@onready var sparkles: CPUParticles2D = $Sparkles

func emit_particles() -> void:
	smokes.emitting = true
	sparkles.emitting = true

func _on_sparkles_finished() -> void:
	queue_free()
