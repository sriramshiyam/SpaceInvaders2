extends Node

func calculate_spring(value: float, spring: Dictionary) -> float:
	var x = value - spring.rest_length
	spring.force = -spring.k * x;
	spring.velocity += spring.force
	value += spring.velocity
	if not is_zero_approx(spring.damping):
		spring.velocity *= spring.damping
	return value

func get_spring(damping: float, k: float, rest_length: float) -> Dictionary:
	var spring: Dictionary = {}
	spring.damping = damping
	spring.k = k
	spring.force = 0
	spring.velocity = 0
	spring.rest_length = rest_length

	return spring
