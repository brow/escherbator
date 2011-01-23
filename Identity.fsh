//
//  Shader.fsh
//  Shaders
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

varying lowp vec2 texture_coordinate; 
uniform sampler2D my_color_texture;

uniform lowp float alpha;
uniform lowp float r1;
uniform lowp float r2;

const highp float PI = 3.1415926535;
const highp float E = 2.71828183;

const bool clipCircle = false;

lowp vec2 polar(lowp vec2 a) {
	lowp float dist = exp(a.x) * r1;
	lowp float angle = a.y;
	return vec2(0.5 + dist * cos(angle), 0.5 + dist * sin(angle));
}

lowp vec2 unpolar(lowp vec2 a) {
	lowp vec2 v = a - vec2(0.5, 0.5);
	lowp float dist = sqrt(v.x * v.x + v.y * v.y);
	lowp float angle = atan(v.y, v.x);
	lowp float y = angle;
	lowp float x = log(dist / r1);
	return vec2(x, y);
}

lowp vec2 tile(lowp vec2 a) {
	// Tile a log(r2/r1) by 2*PI rectangle over the plane.
	lowp float edge, x, y = mod(a.y, 2.0 * PI);
	if (clipCircle) {
		// Clip to circle with radius r2
		x = mod(a.x, log(r2 / r1));
	} else {
		// Clip to image edge. 
		// edge = distance from center to image rect edge along angle y
		// TODO: generalize for non-square image
		lowp float maxEdge = 1.0 / sqrt(2.0), minEdge = 0.5;
		if (abs(sin(y)) < maxEdge)
			edge = abs(0.5 / cos(y));
		else
			edge = abs(0.5 / sin(y));	
		x = a.x;
		x = mod(x , log(r2 / r1));
		if (x < log(edge / r1) - log(r2 / r1))
			x = x + log(r2 / r1);
	}
	return vec2(x, y);
}

lowp vec2 visualize(lowp vec2 a) {
	// Scale (log(r2/r1), 2*PI) to (1,1) for easier visualization).
	lowp mat2 scale = mat2(log(r2 / r1)*2.0, 0 , 0, 2.0 * PI);
	return scale * a;
}

lowp vec2 rotate(lowp vec2 a) {
	/* Translate by (0, -1) in order to rotate about lower-left corner. */
	lowp vec2 translation = vec2(0, -1.0);

	/* Rotate and scale to take upper-right corner to (0, 1). */
	lowp mat2 rotate = mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));
	
	lowp float scaleFactor = 1.0 / cos(alpha);
	lowp mat2 scale = mat2(scaleFactor, 0 , 0, scaleFactor);
	
	return rotate * scale * (a + translation) - translation;
}

void main()
{
	gl_FragColor = texture2D(my_color_texture, polar(tile(rotate(unpolar(texture_coordinate)))));
}
