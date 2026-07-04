shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform vec2 screen_size = vec2(544.0, 306.0);
// uniform float pixel_resolution : hint_range(64.0, 512.0) = 306.0;
uniform int color_steps : hint_range(2, 64) = 256;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.08;
uniform bool enable_dither = true;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.15;

uniform bool enable_glow = true;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.0;
uniform float glow_spread : hint_range(0.001, 0.01) = 0.005;

uniform bool enable_vintage = true;  //  Toggle
uniform float vintage_strength : hint_range(0.0, 1.0) = 0.3;

uniform float vignette_strength : hint_range(0.0, 0.5) = 0.0;
uniform float vignette_radius = 1.0;

uniform float blur_strength : hint_range(0.0, 10.0) = 0.0;

float random(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float bayer_dither(vec2 pos) {
    int x = int(mod(pos.x, 4.0));
    int y = int(mod(pos.y, 4.0));
    int index = x + y * 4;

    float bayer[16] = float[16](
        0.0, 8.0, 2.0, 10.0,
        12.0, 4.0, 14.0, 6.0,
        3.0, 11.0, 1.0, 9.0,
        15.0, 7.0, 13.0, 5.0
    );

    return bayer[index] / 16.0;
}

vec3 get_glow(vec2 uv) {
    vec3 col = vec3(0.0);
    float total = 0.0;

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * glow_spread;
            col += texture(screen_texture, uv + offset).rgb;
            total += 1.0;
        }
    }
    return col / total;
}

vec3 get_blur(vec2 uv) {
    vec3 col = vec3(0.0);

    vec2 offset = (1.0 / screen_size) * blur_strength;

    col += texture(screen_texture, uv + vec2(-offset.x, -offset.y)).rgb;
    col += texture(screen_texture, uv + vec2(0.0, -offset.y)).rgb;
    col += texture(screen_texture, uv + vec2(offset.x, -offset.y)).rgb;

    col += texture(screen_texture, uv + vec2(-offset.x, 0.0)).rgb;
    col += texture(screen_texture, uv).rgb;
    col += texture(screen_texture, uv + vec2(offset.x, 0.0)).rgb;

    col += texture(screen_texture, uv + vec2(-offset.x, offset.y)).rgb;
    col += texture(screen_texture, uv + vec2(0.0, offset.y)).rgb;
    col += texture(screen_texture, uv + vec2(offset.x, offset.y)).rgb;

    return col / 9.0;
}

vec3 apply_black_vintage_edges(vec3 color, vec2 uv) {
    // Distance from screen center
    float dist = distance(uv, vec2(0.5));

    // Mask: only affects edges
    float edge_mask = smoothstep(0.4, 0.8, dist);

    // Blend edges to black
    color = mix(color, vec3(0.0), edge_mask * vintage_strength);

    return color;
}

void fragment() {
    vec2 pixel_uv = UV;

    vec3 color;

    if (blur_strength > 0.0) {
        color = get_blur(pixel_uv);
    } else {
        color = texture(screen_texture, pixel_uv).rgb;
    }

    if (enable_glow) {
        vec3 blurred = get_glow(UV);
        color += blurred * glow_strength;
    }

    float steps = float(color_steps);
    color = floor(color * steps + 0.5) / steps;

    float noise = (random(UV + TIME) - 0.5) * noise_strength;
    color += noise;

    if (enable_dither) {
        float threshold = bayer_dither(FRAGCOORD.xy);
        color += (dither_strength * (threshold - 0.5));
    }

    //  Black vintage only on edges
    if (enable_vintage) {
        color = apply_black_vintage_edges(color, UV);
    }
    
    // Vignette
    vec2 centered = SCREEN_UV * 2.0 - 1.0;
    centered.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    float vig = dot(centered / vignette_radius, centered / vignette_radius);
    color *= 1.0 - vig * vignette_strength;

    COLOR.rgb = clamp(color, 0.0, 1.0);
}
