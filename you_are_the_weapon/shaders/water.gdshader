shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform vec2 speed = vec2(0.5, 0.2);

uniform float wave_strength = 0.1;

uniform float distoartion = 0.01;

void vertex() {
	VERTEX.y += sin(TIME);

}

void fragment() {

	vec2 noise = 2.0 * texture(noise_texture, UV + speed * TIME).rg - vec2(1.0);

	COLOR = texture(TEXTURE, UV + noise * wave_strength);

	COLOR *= texture(screen_texture, SCREEN_UV + noise * distoartion);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
