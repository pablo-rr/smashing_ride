shader_type spatial;
render_mode unshaded;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment(){
//	ALBEDO = vec3(0.0, 0.5, 1.0);
//	ALBEDO = vec3(sin(TIME * 0.2), sin(TIME * 0.4), sin(TIME * 0.6));
	
	ALPHA = 0.065;
}