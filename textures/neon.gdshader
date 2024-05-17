shader_type canvas_item;

uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float glow_intensity : hint_range(0.0, 10.0) = 8.0;
uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 1.0, 1.0); // Neon blue color
uniform float edge_softness : hint_range(0.0, 1.0) = 0.2;
uniform float glow_radius : hint_range(0.0, 1.0) = 0.8; // Increased radius for thicker glow

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    // Calculate the distance from the edge for the glow effect
    float edge_distance = smoothstep(0.0, 1.0 - edge_softness, 1.0 - tex.a * glow_radius);
    
    // Ensure the lines are white
    vec4 base_color = vec4(1.0, 1.0, 1.0, tex.a) * brightness;
    
    // Create the glow effect by blending the glow color with the base color
    vec4 glow = glow_color * glow_intensity * edge_distance;
    
    // Combine the base color and the glow
    base_color.rgb = mix(base_color.rgb, glow.rgb, edge_distance);
    
    // Maintain alpha
    base_color.a = tex.a;
    
    // Output the final color
    COLOR = base_color;
}
