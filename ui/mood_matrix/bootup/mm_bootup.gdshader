shader_type canvas_item;

uniform float k : hint_range(0, 1) = 0.0;
uniform vec4 out_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 in_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);

void fragment() {
	vec4 color = COLOR;
	float k_remapped = clamp((k * 2.0) - 1.0, -1.0, 1.0);
	bool circle = sqrt(pow(UV.x - 0.5, 2.0) + pow(UV.y - 0.5, 2.0)) < 0.5;
	bool inner_circle = (UV.x - 0.5) < sin(PI * k_remapped / 2.0) * sqrt(0.25 - pow(UV.y - 0.5, 2.0));
	bool merged = circle && inner_circle;
	COLOR = merged ? in_color : out_color;
	COLOR.a = circle ? 1.0 : 0.0;
	COLOR *= color;
}
