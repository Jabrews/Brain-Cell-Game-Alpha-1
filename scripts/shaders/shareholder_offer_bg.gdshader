shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 3.0;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 tint_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	vec2 pixel_size = SCREEN_PIXEL_SIZE * blur_amount;

	vec4 blur_color = vec4(0.0);

	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2(-1.0, -1.0));
	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2( 0.0, -1.0));
	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2( 1.0, -1.0));

	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2(-1.0,  0.0));
	blur_color += texture(SCREEN_TEXTURE, screen_uv);
	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2( 1.0,  0.0));

	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2(-1.0,  1.0));
	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2( 0.0,  1.0));
	blur_color += texture(SCREEN_TEXTURE, screen_uv + pixel_size * vec2( 1.0,  1.0));

	blur_color /= 9.0;

	COLOR = mix(blur_color, tint_color, tint_strength);
}
