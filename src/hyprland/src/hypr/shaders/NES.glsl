//https://lospec.com/palette-list/nintendo-entertainment-system
// -*- mode:c -*-
// https://lospec.com/palette-list/pop-laugh-cry
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
    vec3 solarized[55];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.000, 0.000, 0.000);
    solarized[1] = vec3(0.988, 0.988, 0.988);
    solarized[2] = vec3(0.973, 0.973, 0.973);
    solarized[3] = vec3(0.737, 0.737, 0.737);
    solarized[4] = vec3(0.486, 0.486, 0.486);
    solarized[5] = vec3(0.643, 0.894, 0.988);
    solarized[6] = vec3(0.235, 0.737, 0.988);
    solarized[7] = vec3(0.000, 0.471, 0.973);
    solarized[8] = vec3(0.000, 0.000, 0.988);
    solarized[9] = vec3(0.722, 0.722, 0.973);
    solarized[10] = vec3(0.408, 0.533, 0.988);
    solarized[11] = vec3(0.000, 0.345, 0.973);
    solarized[12] = vec3(0.000, 0.000, 0.737);
    solarized[13] = vec3(0.847, 0.722, 0.973);
    solarized[14] = vec3(0.596, 0.471, 0.973);
    solarized[15] = vec3(0.408, 0.267, 0.988);
    solarized[16] = vec3(0.267, 0.157, 0.737);
    solarized[17] = vec3(0.973, 0.722, 0.973);
    solarized[18] = vec3(0.973, 0.471, 0.973);
    solarized[19] = vec3(0.847, 0.000, 0.800);
    solarized[20] = vec3(0.580, 0.000, 0.518);
    solarized[21] = vec3(0.973, 0.643, 0.753);
    solarized[22] = vec3(0.973, 0.345, 0.596);
    solarized[23] = vec3(0.894, 0.000, 0.345);
    solarized[24] = vec3(0.659, 0.000, 0.125);
    solarized[25] = vec3(0.941, 0.816, 0.690);
    solarized[26] = vec3(0.973, 0.471, 0.345);
    solarized[27] = vec3(0.973, 0.220, 0.000);
    solarized[28] = vec3(0.659, 0.063, 0.000);
    solarized[29] = vec3(0.988, 0.878, 0.659);
    solarized[30] = vec3(0.988, 0.627, 0.267);
    solarized[31] = vec3(0.894, 0.361, 0.063);
    solarized[32] = vec3(0.533, 0.078, 0.000);
    solarized[33] = vec3(0.973, 0.847, 0.471);
    solarized[34] = vec3(0.973, 0.722, 0.000);
    solarized[35] = vec3(0.675, 0.486, 0.000);
    solarized[36] = vec3(0.314, 0.188, 0.000);
    solarized[37] = vec3(0.847, 0.973, 0.471);
    solarized[38] = vec3(0.722, 0.973, 0.094);
    solarized[39] = vec3(0.000, 0.722, 0.000);
    solarized[40] = vec3(0.000, 0.471, 0.000);
    solarized[41] = vec3(0.722, 0.973, 0.722);
    solarized[42] = vec3(0.345, 0.847, 0.329);
    solarized[43] = vec3(0.000, 0.659, 0.000);
    solarized[44] = vec3(0.000, 0.408, 0.000);
    solarized[45] = vec3(0.722, 0.973, 0.847);
    solarized[46] = vec3(0.345, 0.973, 0.596);
    solarized[47] = vec3(0.000, 0.659, 0.267);
    solarized[48] = vec3(0.000, 0.345, 0.000);
    solarized[49] = vec3(0.000, 0.988, 0.988);
    solarized[50] = vec3(0.000, 0.910, 0.847);
    solarized[51] = vec3(0.000, 0.533, 0.533);
    solarized[52] = vec3(0.000, 0.251, 0.345);
    solarized[53] = vec3(0.973, 0.847, 0.973);
    solarized[54] = vec3(0.471, 0.471, 0.471);

    vec3 pixColor = vec3(texture2D(tex, v_texcoord));
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 55; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
