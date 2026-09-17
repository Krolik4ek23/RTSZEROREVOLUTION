varying vec2 v_vTexcoord;

uniform vec3 u_Size;

const int Quality = 4;
const int Directions = 8;
const float Pi = 6.28318530718;

void main()
{
    gl_FragColor = texture2D (gm_BaseTexture, v_vTexcoord);
    float luminance = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.0;
    gl_FragColor.rgb = vec3(luminance);
}