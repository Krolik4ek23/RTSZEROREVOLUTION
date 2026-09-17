varying vec2 v_vTexcoord;

uniform vec3 u_Size;

const int Quality = 4;
const int Directions = 8;
const float Pi = 6.28318530718;

void main()
{
    vec2 R = u_Size.z / u_Size.xy;
    float Z = texture2D(gm_BaseTexture, v_vTexcoord).a;
	
    for(float j = 0.0; j < Pi; j += Pi / float(Directions)){
        for(float i = 1.0 / float(Quality); i <= 1.0; i += 1.0 / float(Quality)){
            Z += texture2D(gm_BaseTexture, v_vTexcoord + vec2(cos(j), sin(j)) * R * i).a;
        }
    }
    Z /= float(Quality) * float(Directions) + 1.0;
    gl_FragColor = vec4(0, 0, 0, Z);
}