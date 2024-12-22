shader_type canvas_item;

uniform vec4 original_colors[10] : source_color;
uniform vec4 replace_colors[10] : source_color;
uniform float strength : hint_range(0.0, 1.0); // Controls the intensity of the color shift

const float precision = 0.1;

vec4 swap_color(vec4 color) {
    for (int i = 0; i < 10; i++) {
        if (distance(color, original_colors[i]) <= precision) {
            return mix(color, replace_colors[i], strength); // Blend based on strength
        }
    }
    return color;
}

void fragment() {
    COLOR = swap_color(texture(TEXTURE, UV));
}
