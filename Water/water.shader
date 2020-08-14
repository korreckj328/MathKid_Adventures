shader_type canvas_item;

uniform vec4 blueTint: hint_color;
uniform vec2 spriteScale = vec2(16.0f, 9.0f);
uniform float scaleX = 0.6333f;
uniform vec2 tiledFactor = vec2(20.0f, 2.0f);

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.9898f, 78.233f))) * 43758.5453123f);
}

float noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	// four corners surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0f, 0.0f));
	float c = rand(i + vec2(0.0f, 1.0f));
	float d = rand(i + vec2(1.0f, 1.0f));
	
	vec2 cubic = f * f * (3.0f - 2.0f * f);
	
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0f * cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment() {
	vec2 tiledUVs = UV * tiledFactor;
	tiledUVs.y *= (spriteScale.x / spriteScale.y);
	
	vec2 noiseCoord1 = tiledUVs * spriteScale * scaleX;
	vec2 noiseCoord2 = tiledUVs * spriteScale * scaleX + 4.0f;
	
	vec2 motion1 = vec2(sin(TIME + tiledUVs.x + tiledUVs.y) * 0.5f, (cos(TIME + tiledUVs.x + tiledUVs.y) * 0.5));
	vec2 motion2 = vec2(sin(TIME + tiledUVs.x + tiledUVs.y) * 0.1f, (sin(TIME + tiledUVs.x + tiledUVs.y) * 0.05f));
	
	vec2 distortion1 = vec2(noise(noiseCoord1 + motion1), noise(noiseCoord2 + motion1)) - vec2(0.5f);
	vec2 distortion2 = vec2(noise(noiseCoord1 + motion2), noise(noiseCoord2 + motion2)) - vec2(0.5f);
	
	vec2 distortionSum = (distortion1 + distortion2) / 60.0f;
	
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV + distortionSum * 2.0f, 0.0f);
	vec4 background = textureLod(TEXTURE, tiledUVs + distortionSum * 5.5f, 0.0f);
	color = mix(background, color, 0.3f);
	color = mix(color, blueTint, 0.5f);
	color.rgb = mix(vec3(0.5f), color.rgb, 1.4f);
	
	float nearTop = (tiledUVs.y + distortionSum.y) / (0.8f / spriteScale.y);
	nearTop = clamp(nearTop, 0.0f, 1.0f);
	nearTop = 1.0f - nearTop;
	
	float edgeLower = 0.6f;
	float edgeUpper = edgeLower + 0.3f;
	
	color = mix(color, vec4(1.0f), nearTop);
	if (nearTop > edgeLower) {
		color.a = 0.0f;
		
		if (nearTop < edgeUpper) {
			color.a = (edgeUpper - nearTop) / (edgeUpper - edgeLower);
		}
	}
	
	
	COLOR = color;
}