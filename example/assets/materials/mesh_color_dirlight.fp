varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump float var_unlit;
varying mediump vec4 var_color;

uniform mediump vec4 tint;
uniform mediump vec4 light_direction;
uniform mediump vec4 ambient_color;
uniform mediump vec4 directional_light;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec3 unlit_color = var_color.rgb * tint_pm.rgb;
    vec3 color = unlit_color.rgb;

    // Directional light
    float ambient_strength = ambient_color.w;
    vec3 ambient = ambient_strength * ambient_color.rgb;
    float diff_light = max(dot(var_normal, normalize(-light_direction.xyz)), 0.0) * directional_light.w;

    // Final composition
    float gamma = 2.2;
    vec3 comp = min(color.rgb * min(diff_light + ambient, vec3(1.0)), vec3(1.0));
    gl_FragColor = vec4(pow(mix(comp, unlit_color, var_unlit), vec3(1.0 / gamma)), 1.0);
}

