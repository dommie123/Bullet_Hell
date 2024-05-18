shader_type canvas_item;

uniform sampler2D texture_to_scroll;
uniform vec2 texture_size; // This will be passed from the script
uniform vec2 scroll_speed = vec2(0.1, 0.1); // Adjust as needed
uniform vec2 scroll_direction = vec2(1.0, 1.0); // Adjust as needed

void fragment() {
    // Get the UV coordinates
    vec2 uv = FRAGCOORD.xy / texture_size;

    // Calculate the offset based on time and scroll speed
    vec2 offset = TIME * scroll_speed * scroll_direction;

    // Apply the offset to UV coordinates
    uv += offset;

    // Wrap the UV coordinates to keep them within [0, 1]
    uv = fract(uv);

    // Sample the texture and assign to color
    COLOR = texture(texture_to_scroll, uv);
}
