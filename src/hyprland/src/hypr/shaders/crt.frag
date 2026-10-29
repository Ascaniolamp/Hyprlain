precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

uniform mediump float time;

const float display_framerate = 60.0;
const vec2 display_resolution = vec2(2520.0, 1680.0);

const int samples =
    5; // pixels per axis; higher = bigger glow, worse performance
const float quality = 2.5; // lower = smaller glow, better quality

vec4 bloom(vec4 colour, sampler2D tex, vec2 tc, vec2 sc) {
  vec4 source = texture2D(tex, tc);
  vec4 sum = vec4(0.0);
  int diff = (samples - 1) / 2;
  vec2 sizeFactor = vec2(1) / display_resolution * quality;

  for (int x = -diff; x <= diff; x++) {
    for (int y = -diff; y <= diff; y++) {
      vec2 offset = vec2(x, y) * sizeFactor;
      sum += texture2D(tex, tc + offset);
    }
  }

  return ((sum / (float(samples) * float(samples))) + source) * colour;
}

// Entry.
void main() {
  vec4 color = texture2D(tex, v_texcoord);

  vec4 bloomed = bloom(color, tex, vec2(20.01, 8.0), vec2(80.1, 40.0));

  color.rgb = bloomed.rgb;

  color.a = 1.0;

  gl_FragColor = color;
}
