shader_type canvas_item;

uniform float speed = 0.2;
uniform float len = 50.0;

void fragment() {
	COLOR.a = texture(TEXTURE, vec2(UV.x * len/100.0, TIME*speed)).r;
	//COLOR.rgb = vec3(UV.x,0.0,0.0);
}
