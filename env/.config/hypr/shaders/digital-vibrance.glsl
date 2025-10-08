#version 330 core

// Compatible con versiones antiguas de Hyprshade
in vec2 v_texcoord;
out vec4 out_color;

uniform sampler2D tex;
uniform float vibrance =1.7;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float avg = (color.r + color.g + color.b) / 3.0;

    // Aumenta saturación (tipo “Digital Vibrance”)
    color.rgb += (color.rgb - avg) * (vibrance - 1.0);

    out_color = vec4(clamp(color.rgb, 0.0, 1.0), color.a);
}
