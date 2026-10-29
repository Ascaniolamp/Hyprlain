//https://lospec.com/palette-list/resurrect-64
// low precision for performance
// NOTE: TAKES HEAVY INSPIRATION FROM https://github.com/0x15BA88FF/hyprshaders/blob/main/shaders/solarized.glsl
// ALL CREDIT WHERE IT's DUE!
// //WARNING!! BAD PERFORMANCE!

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
    vec3 solarized[64];
    //corresponds to RGB values.
    //ascending from 0-1
    //Apparently it can go above 1?
    //you can do 1.1 and it works.
    //not sure why
    solarized[0] = vec3(0.180, 0.133, 0.184);
    solarized[1] = vec3(0.243, 0.208, 0.275);
    solarized[2] = vec3(0.384, 0.333, 0.396);
    solarized[3] = vec3(0.588, 0.424, 0.424);
    solarized[4] = vec3(0.671, 0.580, 0.478);
    solarized[5] = vec3(0.412, 0.310, 0.384);
    solarized[6] = vec3(0.498, 0.439, 0.541);
    solarized[7] = vec3(0.608, 0.671, 0.698);
    solarized[8] = vec3(0.780, 0.863, 0.816);
    solarized[9] = vec3(1.000, 1.000, 1.000);
    solarized[10] = vec3(0.431, 0.153, 0.153);
    solarized[11] = vec3(0.702, 0.220, 0.192);
    solarized[12] = vec3(0.918, 0.310, 0.212);
    solarized[13] = vec3(0.961, 0.490, 0.290);
    solarized[14] = vec3(0.682, 0.137, 0.204);
    solarized[15] = vec3(0.910, 0.231, 0.231);
    solarized[16] = vec3(0.984, 0.420, 0.114);
    solarized[17] = vec3(0.969, 0.588, 0.090);
    solarized[18] = vec3(0.977, 0.761, 0.169);
    solarized[19] = vec3(0.478, 0.188, 0.271);
    solarized[20] = vec3(0.620, 0.271, 0.224);
    solarized[21] = vec3(0.804, 0.408, 0.239);
    solarized[22] = vec3(0.902, 0.565, 0.306);
    solarized[23] = vec3(0.984, 0.726, 0.329);
    solarized[24] = vec3(0.298, 0.243, 0.141);
    solarized[25] = vec3(0.404, 0.400, 0.200);
    solarized[26] = vec3(0.635, 0.663, 0.278);
    solarized[27] = vec3(0.835, 0.878, 0.294);
    solarized[28] = vec3(0.984, 1.000, 0.526);
    solarized[29] = vec3(0.086, 0.353, 0.298);
    solarized[30] = vec3(0.137, 0.565, 0.388);
    solarized[31] = vec3(0.118, 0.737, 0.451);
    solarized[32] = vec3(0.569, 0.859, 0.412);
    solarized[33] = vec3(0.804, 0.875, 0.424);
    solarized[34] = vec3(0.192, 0.212, 0.220);
    solarized[35] = vec3(0.216, 0.306, 0.290);
    solarized[36] = vec3(0.329, 0.494, 0.392);
    solarized[37] = vec3(0.573, 0.663, 0.518);
    solarized[38] = vec3(0.698, 0.729, 0.565);
    solarized[39] = vec3(0.043, 0.369, 0.396);
    solarized[40] = vec3(0.043, 0.541, 0.561);
    solarized[41] = vec3(0.055, 0.686, 0.608);
    solarized[42] = vec3(0.188, 0.882, 0.726);
    solarized[43] = vec3(0.561, 0.973, 0.886);
    solarized[44] = vec3(0.196, 0.200, 0.326);
    solarized[45] = vec3(0.282, 0.290, 0.467);
    solarized[46] = vec3(0.302, 0.396, 0.706);
    solarized[47] = vec3(0.302, 0.608, 0.902);
    solarized[48] = vec3(0.561, 0.828, 1.000);
    solarized[49] = vec3(0.271, 0.161, 0.247);
    solarized[50] = vec3(0.420, 0.243, 0.459);
    solarized[51] = vec3(0.565, 0.369, 0.663);
    solarized[52] = vec3(0.659, 0.518, 0.953);
    solarized[53] = vec3(0.918, 0.678, 0.929);
    solarized[54] = vec3(0.459, 0.235, 0.329);
    solarized[55] = vec3(0.635, 0.294, 0.435);
    solarized[56] = vec3(0.812, 0.396, 0.498);
    solarized[57] = vec3(0.929, 0.502, 0.600);
    solarized[58] = vec3(0.514, 0.110, 0.365);
    solarized[59] = vec3(0.765, 0.141, 0.329);
    solarized[60] = vec3(0.941, 0.310, 0.471);
    solarized[61] = vec3(0.965, 0.506, 0.506);
    solarized[62] = vec3(0.988, 0.655, 0.565);
    solarized[63] = vec3(0.992, 0.796, 0.690);

    vec3 currcolor = vec3(texture2D(tex, v_texcoord));

    vec3 pixColor = invertThis(currcolor);
    int closest = 0;
    float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
    for (int i = 1; i < 64; i++) {
        float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
        if (newDistanceSquared < closestDistanceSquared) {
            closest = i;
            closestDistanceSquared = newDistanceSquared;
        }
    }
    gl_FragColor = vec4(solarized[closest], 1.);
}
