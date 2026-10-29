// -*- mode:c -*-
// low precision for performance
// NOTE: TAKES HEAVY INSPIRATION FROM https://github.com/0x15BA88FF/hyprshaders/blob/main/shaders/solarized.glsl
// ALL CREDIT WHERE IT's DUE!

//to summarize what's happening here:
//we create an array full of rgb values
//we then take the RGB value of every pixel on screen
//and we basically roughly "shove" the color of every pixel on screen
//into a rgb value

//im not sure how good this is performance/battery-wise, but it looks good so w/e

precision lowp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

float distanceSquared(vec3 pixColor, vec3 solarizedColor) {
    vec3 distanceVector = pixColor - solarizedColor;
    return dot(distanceVector, distanceVector);
}

void main() {
    vec3 solarized[8];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.098, 0.114, 0.118); // #191d1e
    solarized[1] = vec3(0.247, 0.271, 0.314); // #3f4550
    solarized[2] = vec3(0.439, 0.471, 0.478); // #70787a
    solarized[3] = vec3(0.753, 0.749, 0.753); // #c0bfc0
    solarized[4] = vec3(0.918, 0.898, 0.886); // #eae5e2
    solarized[5] = vec3(0.729, 0.667, 0.569); // #baaa91
    solarized[6] = vec3(0.529, 0.455, 0.349); // #877459
    solarized[7] = vec3(0.325, 0.294, 0.227); // #534b3a

    vec3 pixColor = vec3(texture2D(tex, v_texcoord));
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 8; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
