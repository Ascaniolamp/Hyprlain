
precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

uniform mediump float time;

const float display_framerate = 60.0;
const vec2 display_resolution = vec2(2520.0, 1680.0);

const float gamma = 1.0;

float rand(vec2 uv, float t) {
  return fract(sin(dot(uv, vec2(1225.6548, 321.8942))) * 4251.4865 + t);
}

float Sigmoid(float x) { return 1.0 / (1.0 + (exp(-(x - 0.5) * 14.0))); }

// Entry.
void main() {
  vec4 color = texture2D(tex, v_texcoord);

  color = vec4(Sigmoid(color.r), Sigmoid(color.g), Sigmoid(color.b), 1.0);

  color = pow(color, vec4(gamma));

  color.a = 1.0;

  gl_FragColor = color;
}