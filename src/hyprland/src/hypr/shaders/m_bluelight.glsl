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

vec3 invertThis(vec3 currentpixels){
    //vec3 newcolor = vec3(1 - currentpixels.r, 1 - currentpixels.g , 1 - currentpixels.b);
    vec3 onevector = vec3(1,1,1);
    vec3 newcolor = onevector - currentpixels;
    return newcolor;
}

float distanceSquared(vec3 pixColor, vec3 solarizedColor) {
	vec3 distanceVector = pixColor - solarizedColor;
	return dot(distanceVector, distanceVector);
}

void main() {
	vec3 solarized[10];
	//corresponds to RGB values.
	//ascending from 0-1
	//Apparently it can go above 1?
	//you can do 1.1 and it works.
	//not sure why
	solarized[0] = vec3(0.1,0.1,0.1);
	solarized[1] = vec3(0.1,0.1,0.2);
	solarized[2] =  vec3(0.1,0.1,0.3);
	solarized[3]  = vec3(0.1,0.1,0.4);
	solarized[4]  = vec3(0.1,0.1,0.5);
	solarized[5]  = vec3(0.1,0.1,0.6);
	solarized[6]  = vec3(0.1,0.1,0.7);
	solarized[7]  = vec3(0.1,0.1,0.8);
	solarized[8]  = vec3(0.1,0.1,0.9);
	solarized[9]  = vec3(0.1,0.1,1.0);


	vec3 currcolor = vec3(texture2D(tex, v_texcoord));

   vec3 pixColor = invertThis(currcolor);
	int closest = 0;
	float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
	for (int i = 1; i < 10; i++) {
		float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
		if (newDistanceSquared < closestDistanceSquared) {
			closest = i;
			closestDistanceSquared = newDistanceSquared;
		}
	}
	gl_FragColor = vec4(solarized[closest], 1.);
}
