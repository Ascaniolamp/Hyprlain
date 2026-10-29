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
    solarized[0] = vec3(0.827, 0.933, 0.827); // #d3eed3
    solarized[1] = vec3(0.576, 0.831, 0.710); // #93d4b5
    solarized[2] = vec3(0.373, 0.702, 0.569); // #5fb391
    solarized[3] = vec3(0.380, 0.549, 0.439); // #618c70
    solarized[4] = vec3(0.404, 0.447, 0.333); // #677255
    solarized[5] = vec3(0.471, 0.282, 0.165); // #78482a
    solarized[6] = vec3(0.388, 0.118, 0.090); // #631e17
    solarized[7] = vec3(0.239, 0.020, 0.090); // #3d0517

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
