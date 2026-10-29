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
    vec3 solarized[9];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.980, 0.980, 0.980); // #fafafa
    solarized[1] = vec3(0.831, 0.847, 0.878); // #d4d8e0
    solarized[2] = vec3(0.675, 0.675, 0.675); // #acacac
    solarized[3] = vec3(0.569, 0.545, 0.549); // #918b8c
    solarized[4] = vec3(0.420, 0.380, 0.369); // #6b615e
    solarized[5] = vec3(0.231, 0.204, 0.180); // #3b342e
    solarized[6] = vec3(0.141, 0.129, 0.102); // #24211a
    solarized[7] = vec3(0.055, 0.051, 0.039); // #0e0d0a
    solarized[8] = vec3(0.012, 0.008, 0.004); // #030201

    vec3 pixColor = vec3(texture2D(tex, v_texcoord));
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 9; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
