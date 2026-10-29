precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    pixColor.rgb = 1.0 - pixColor.rgb;
    gl_FragColor = pixColor;
}
