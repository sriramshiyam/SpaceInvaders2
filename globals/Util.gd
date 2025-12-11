extends Node

func get_spring(damping: float, k: float, rest_length: float) -> Dictionary:
	var spring: Dictionary = {}
	spring.damping = damping
	spring.k = k
	spring.force = 0
	spring.velocity = 0
	spring.rest_length = rest_length

	return spring
