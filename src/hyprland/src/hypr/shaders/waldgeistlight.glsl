//https://lospec.com/palette-list/waldgeist
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

vec3 invertThis(vec3 currentpixels) {
    //vec3 newcolor = vec3(1 - currentpixels.r, 1 - currentpixels.g , 1 - currentpixels.b);
    vec3 onevector = vec3(1, 1, 1);
    vec3 newcolor = onevector - currentpixels;
    return newcolor;
}

float distanceSquared(vec3 pixColor, vec3 solarizedColor) {
    vec3 distanceVector = pixColor - solarizedColor;
    return dot(distanceVector, distanceVector);
}

void main() {
    vec3 solarized[39];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.651, 0.533, 0.290);
    solarized[1] = vec3(0.565, 0.424, 0.188);
    solarized[2] = vec3(0.510, 0.326, 0.216);
    solarized[3] = vec3(0.514, 0.278, 0.239);
    solarized[4] = vec3(0.400, 0.208, 0.180);
    solarized[5] = vec3(0.337, 0.161, 0.137);
    solarized[6] = vec3(0.380, 0.149, 0.220);
    solarized[7] = vec3(0.275, 0.200, 0.173);
    solarized[8] = vec3(0.196, 0.196, 0.188);
    solarized[9] = vec3(0.243, 0.251, 0.333);
    solarized[10] = vec3(0.220, 0.176, 0.208);
    solarized[11] = vec3(0.196, 0.231, 0.259);
    solarized[12] = vec3(0.122, 0.176, 0.212);
    solarized[13] = vec3(0.078, 0.122, 0.145);
    solarized[14] = vec3(0.043, 0.063, 0.086);
    solarized[15] = vec3(0.141, 0.322, 0.451);
    solarized[16] = vec3(0.306, 0.455, 0.600);
    solarized[17] = vec3(0.369, 0.494, 0.545);
    solarized[18] = vec3(0.475, 0.541, 0.573);
    solarized[19] = vec3(0.529, 0.620, 0.639);
    solarized[20] = vec3(0.890, 0.867, 0.820);
    solarized[21] = vec3(0.741, 0.733, 0.682);
    solarized[22] = vec3(0.686, 0.620, 0.580);
    solarized[23] = vec3(0.565, 0.486, 0.459);
    solarized[24] = vec3(0.635, 0.624, 0.494);
    solarized[25] = vec3(0.588, 0.576, 0.447);
    solarized[26] = vec3(0.471, 0.451, 0.365);
    solarized[27] = vec3(0.412, 0.388, 0.326);
    solarized[28] = vec3(0.310, 0.286, 0.231);
    solarized[29] = vec3(0.129, 0.145, 0.157);
    solarized[30] = vec3(0.349, 0.361, 0.333);
    solarized[31] = vec3(0.294, 0.306, 0.310);
    solarized[32] = vec3(0.341, 0.337, 0.165);
    solarized[33] = vec3(0.404, 0.373, 0.188);
    solarized[34] = vec3(0.447, 0.447, 0.204);
    solarized[35] = vec3(0.451, 0.502, 0.294);
    solarized[36] = vec3(0.373, 0.482, 0.325);
    solarized[37] = vec3(0.231, 0.427, 0.384);
    solarized[38] = vec3(0.196, 0.325, 0.290);

    vec3 currcolor = vec3(texture2D(tex, v_texcoord));

    vec3 pixColor = invertThis(currcolor);
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 39; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
