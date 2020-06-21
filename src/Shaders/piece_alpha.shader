shader_type canvas_item;
render_mode unshaded;
uniform sampler2D mask: hint_white;
uniform vec2 region_origin;
uniform vec2 region_size;
uniform vec2 texture_size;

void fragment() {
	
	vec2 uv_offset = region_origin;
	vec2 uv_scale = region_size / texture_size;
	
	// Alpha Mask
    vec4 ctex = texture(TEXTURE, UV);
	vec4 cmask = texture(mask, (UV / uv_scale) + (uv_offset / uv_scale));
	float cmask_comp = cmask.r + cmask.g + cmask.b;
	ctex.a = cmask_comp / 3.0;
	
	// Bevel
	
    COLOR = ctex;
}