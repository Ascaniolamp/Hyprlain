
#define PI 3.14159265359
#define PHI 1.61803398875

#define SAMPLES 30
#define BLOOM_RADIUS 80.0

// from https://github.com/TheRealMJP/BakingLab/blob/master/BakingLab/ACES.hlsl
const mat3 ACESInputMat = mat3(0.59719, 0.35458, 0.04823, 0.07600, 0.90834,
                               0.01566, 0.02840, 0.13383, 0.83777);

const mat3 ACESOutputMat = mat3(1.60475, -0.53108, -0.07367, -0.10208, 1.10813,
                                -0.00605, -0.00327, -0.07276, 1.07602);

vec3 RRTAndODTFit(in vec3 v) {
  vec3 a = v * (v + 0.0245786) - 0.000090537;
  vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;
  return a / b;
}

vec3 ACESFitted(in vec3 color) {
  color = color * ACESInputMat;
  color = RRTAndODTFit(color);
  color = color * ACESOutputMat;
  color = clamp(color, 0.0, 1.0);
  return color;
}

// Dave_Hoskins hash
#define HASHSCALE3 vec3(.1031, .1030, .0973)
vec3 hash33(in vec3 p3) {
  p3 = fract(p3 * HASHSCALE3);
  p3 += dot(p3, p3.yxz + 19.19);
  return fract((p3.xxy + p3.yxx) * p3.zyx);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

  vec3 bloom = vec3(0);
  float totfac = 0.0;

  vec3 rnd = hash33(vec3(fragCoord, iFrame));
  float offset = rnd.x * 2.0 * PI;

  // bloom
  for (int i = 0; i < SAMPLES; i++) {
    float theta = 2.0 * PI * PHI * float(i) + offset;
    float radius = sqrt(float(i)) / sqrt(float(SAMPLES));
    radius *= BLOOM_RADIUS;
    vec2 offset = vec2(cos(theta), sin(theta)) * radius;
    vec2 delta = vec2(1.0 + exp(-abs(offset.y) * 0.1), 0.5);
    offset *= delta;
    vec4 here = textureGrad(iChannel0, (fragCoord + offset) / iResolution.xy,
                            vec2(.02, 0), vec2(0, 0.02));
    float fact = smoothstep(BLOOM_RADIUS, 0.0, radius);
    bloom += here.rgb * 0.05 * fact;
    totfac += fact;
  }

  bloom /= totfac;

  // chromatic aberration
  vec2 uv = fragCoord / iResolution.xy;
  vec2 mo = uv * 2.0 - 1.0;
  mo *= 0.01;
  fragColor.r = textureLod(iChannel0, uv - mo * 0.1, 0.0).r;
  fragColor.g = textureLod(iChannel0, uv - mo * 0.6, 0.0).g;
  fragColor.b = textureLod(iChannel0, uv - mo * 1.0, 0.0).b;

  // add bloom
  fragColor.rgb += bloom;
  // vignette
  vec2 vi = fragCoord / iResolution.xy * 2.0 - 1.0;
  fragColor.rgb *= (1.0 - sqrt(dot(vi, vi) * 0.45));
  // tonemapping
  fragColor.rgb = ACESFitted(fragColor.rgb);
  // gamma correction
  fragColor.rgb = pow(fragColor.rgb, vec3(1.0 / 2.2));
  // dithering
  fragColor.rgb += (rnd - 0.5) * 0.1;
}