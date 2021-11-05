shader_type canvas_item;
render_mode unshaded;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = vec4(1.2 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
}