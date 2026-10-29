
precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

uniform mediump float time;

const float display_framerate = 60.0;
const vec2 display_resolution = vec2(2520.0, 1680.0);

float rand(vec2 uv, float t) {
  return fract(sin(dot(uv, vec2(1225.6548, 321.8942))) * 4251.4865 + t);
}

// Entry.
void main() {
  vec4 color = texture2D(tex, v_texcoord);

  vec2 ps = vec2(1.0) / display_resolution;
  vec2 uv = v_texcoord * ps;

  // Grain
  float scale = 5.0;
  float amount = 0.3;

  vec2 offset = (rand(v_texcoord, time) - 0.5) * 2.0 * v_texcoord * scale;
  vec3 noise = texture2D(tex, uv + offset).rgb;
  color.rgb = mix(color.rgb, noise, amount);
  ////////

  color.a = 1.0;

  gl_FragColor = color;
}