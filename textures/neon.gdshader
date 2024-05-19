shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.2, 0.6, 0.3, 1.0);
uniform float glow_power : hint_range(0.0, 20.0, 0.1) = 10.0;
uniform float glow_shift : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float glow_radius : hint_range(1.0, 20.0, 1.0) = 5.0;
uniform vec2 texture_size = vec2(256.0, 256.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 glow = vec4(0.0);
    float count = 0.0;
    vec2 texture_pixel_size = vec2(1.0) / texture_size;

    for (float x = -glow_radius; x <= glow_radius; x += 0.5) {
        for (float y = -glow_radius; y <= glow_radius; y += 0.5) {
            float distance = length(vec2(x, y));
            if (distance <= glow_radius) {
                vec2 offset = vec2(x, y) * glow_shift * texture_pixel_size;
                glow += texture(TEXTURE, UV + offset) * glow_color * (1.0 - distance / glow_radius);
                count += 1.0;
            }
        }
    }

    glow = glow_power * (glow / count);
    vec4 result_color = tex + glow * glow.a;
    COLOR = vec4(result_color.rgb, tex.a); 
}
