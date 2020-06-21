shader_type canvas_item;

uniform vec2 size;

void fragment() {
	
	COLOR.rgb = textureLod(TEXTURE, round(UV * size) / size, 0.0).rgb;
}