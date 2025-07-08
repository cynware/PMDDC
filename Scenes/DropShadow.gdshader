shader_type canvas_item;

uniform vec2 shadow_offset_1 = vec2(0.0, 0.0); // → Right
uniform vec2 shadow_offset_2 = vec2(0.0, 0.0); // ↓ Down
uniform vec4 shadow_color = vec4(0.0, 0.0, 0.0, 1); // Shadow color

uniform vec2 texture_size = vec2(220.0, 39.0);

void fragment() {
    vec2 pixel_offset_1 = shadow_offset_1 / texture_size;
    vec2 pixel_offset_2 = shadow_offset_2 / texture_size;

    vec4 color_main = texture(TEXTURE, UV);
    vec4 shadow1 = texture(TEXTURE, UV - pixel_offset_1) * shadow_color;
    vec4 shadow2 = texture(TEXTURE, UV - pixel_offset_2) * shadow_color;

    COLOR = shadow1 + shadow2 + color_main;
}