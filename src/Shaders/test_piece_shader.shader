shader_type canvas_item;

uniform vec2 resolution;
uniform vec2 region_size;
uniform sampler2D tex;

void fragment() {
	vec2 tex_scale = vec2(textureSize(TEXTURE, 0)) / region_size;
	vec2 interval = 1.0 / resolution;
	vec2 sample_UV = (UV * tex_scale) - mod((UV * tex_scale), interval);
	
	vec4 p = texture(TEXTURE, UV - mod(UV, interval));
	vec4 t = texture(tex, sample_UV);
	
	p = (p + t) / 2.0;
	
	COLOR = p;
}