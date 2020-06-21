shader_type canvas_item;
render_mode unshaded;

uniform sampler2D mask;
uniform vec2 target_size;
uniform vec2 region_size;
uniform vec2 region_origin;


vec2 m_uv_rescaled(sampler2D tex, vec2 uv) {
	// Scale UVs to texture size & region
	vec2 scale = vec2(textureSize(tex, 0)) / region_size;
	vec2 offset = region_origin * scale;
	vec2 m_uv = (uv * scale) +  offset; // Offset mask to region
	// 'Pixelate' to get standard resolution
	vec2 interval = 1.0 / target_size;
	vec2 sample_UV = m_uv - mod(m_uv, interval);
    return sample_UV;
}


vec2 p_uv_rescaled(sampler2D tex, vec2 uv) {
	// Scale UVs to region (rest is fine)
	vec2 scale = vec2(textureSize(tex, 0)) / region_size;
	// 'Pixelate' to get standard resolution
	vec2 interval = 1.0 / (target_size * scale);
	vec2 sample_UV = uv - mod(uv, interval);
    return sample_UV;
}


void fragment() {
	
	vec4 p = textureLod(TEXTURE, p_uv_rescaled(TEXTURE, UV), 0.0);
	vec4 m = textureLod(mask, m_uv_rescaled(TEXTURE, UV), 0.0);

	// Alpha mask
	p.a = m.a;
	
	// Color
	vec3 lighten = clamp(m.rgb - 0.5, vec3(0.0), vec3(0.5));
	vec3 darken = clamp(0.5 - m.rgb, vec3(0.0), vec3(0.5));

	p.rgb += lighten;
	p.rgb -= darken;
	
    COLOR = p;
	
}