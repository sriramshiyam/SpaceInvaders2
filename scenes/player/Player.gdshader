shader_type canvas_item;

uniform bool red_alpha = false;

void fragment() {
	if (red_alpha && COLOR.a != 0.0) {
		COLOR = mix(COLOR, vec4(1.0, 0.0, 0.0, 1.0), abs(sin(TIME * 3.0)));
	}
}
