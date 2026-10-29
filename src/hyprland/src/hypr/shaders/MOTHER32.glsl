//https://lospec.com/palette-list/mother32

//ok this one is really good
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
    vec3 solarized[32];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.220, 0.161, 0.278);
    solarized[1] = vec3(0.133, 0.090, 0.208);
    solarized[2] = vec3(0.078, 0.063, 0.173);
    solarized[3] = vec3(0.012, 0.020, 0.110);
    solarized[4] = vec3(0.020, 0.043, 0.271);
    solarized[5] = vec3(0.024, 0.071, 0.357);
    solarized[6] = vec3(0.031, 0.102, 0.439);
    solarized[7] = vec3(0.110, 0.271, 0.506);
    solarized[8] = vec3(0.020, 0.380, 0.478);
    solarized[9] = vec3(0.204, 0.447, 0.533);
    solarized[10] = vec3(0.341, 0.533, 0.494);
    solarized[11] = vec3(0.592, 0.616, 0.557);
    solarized[12] = vec3(0.965, 0.933, 0.890);
    solarized[13] = vec3(0.914, 0.843, 0.796);
    solarized[14] = vec3(0.835, 0.698, 0.624);
    solarized[15] = vec3(0.792, 0.604, 0.541);
    solarized[16] = vec3(0.651, 0.514, 0.427);
    solarized[17] = vec3(0.443, 0.333, 0.290);
    solarized[18] = vec3(0.349, 0.239, 0.235);
    solarized[19] = vec3(0.486, 0.220, 0.204);
    solarized[20] = vec3(0.561, 0.228, 0.216);
    solarized[21] = vec3(0.427, 0.169, 0.184);
    solarized[22] = vec3(0.314, 0.126, 0.157);
    solarized[23] = vec3(0.145, 0.035, 0.118);
    solarized[24] = vec3(0.220, 0.098, 0.220);
    solarized[25] = vec3(0.263, 0.133, 0.231);
    solarized[26] = vec3(0.278, 0.161, 0.267);
    solarized[27] = vec3(0.384, 0.282, 0.408);
    solarized[28] = vec3(0.757, 0.541, 0.553);
    solarized[29] = vec3(0.604, 0.365, 0.392);
    solarized[30] = vec3(0.533, 0.290, 0.341);
    solarized[31] = vec3(0.769, 0.263, 0.282);

    vec3 pixColor = vec3(texture2D(tex, v_texcoord));
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 32; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
