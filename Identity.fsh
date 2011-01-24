//
//  Shader.fsh
//  Shaders
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

varying highp vec2 texture_coordinate; 
uniform sampler2D my_color_texture;

uniform highp float alpha;
uniform highp float r1;
uniform highp float r2;

const highp float PI = 3.1415926535;
const highp float E = 2.71828183;

highp vec2 polar(highp vec2 a) {
	highp float dist = exp(a.x) * r1;
	highp float angle = a.y;
	return vec2(0.5 + dist * cos(angle), 0.5 + dist * sin(angle));
}

highp vec2 unpolar(highp vec2 a) {
	highp vec2 v = a - vec2(0.5, 0.5);
	highp float dist = sqrt(v.x * v.x + v.y * v.y);
	highp float angle = atan(v.y, v.x);
	highp float y = angle;
	highp float x = log(dist / r1);
	return vec2(x, y);
}

highp vec2 tile(highp vec2 a) {
	// Tile a log(r2/r1) by 2*PI rectangle over the plane.
	return vec2(mod(a.x, log(r2 / r1)),
				mod(a.y, 2.0 * PI));
}

highp vec2 tile_unclipped(highp vec2 a) {
	// Tile the plane with a non-rectangular tile based on
	// clipping at the image edge rather than at 
	highp float edge, x, y = mod(a.y, 2.0 * PI);
	// Clip to image edge. 
	// edge = distance from center to image rect edge along angle y
	// TODO: generalize for non-square image
	highp float maxEdge = 1.0 / sqrt(2.0), minEdge = 0.5;
	if (abs(sin(y)) < maxEdge)
		edge = abs(0.5 / cos(y));
	else
		edge = abs(0.5 / sin(y));	
	x = a.x;
	x = mod(x , log(r2 / r1));
	if (x < log(edge / r1) - log(r2 / r1))
		x = x + log(r2 / r1);
	return vec2(x, y);
}

highp vec2 visualize(highp vec2 a) {
	// Scale (log(r2/r1), 2*PI) to (1,1) for easier visualization).
	highp mat2 scale = mat2(log(r2 / r1)*2.0, 0 , 0, 2.0 * PI);
	return scale * a;
}

highp vec2 rotate(highp vec2 a) {
	/* Translate by (0, -1) in order to rotate about lower-left corner. */
	highp vec2 translation = vec2(0, -1.0);

	/* Rotate and scale to take upper-right corner to (0, 1). */
	highp mat2 rotate = mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));
	
	highp float scaleFactor = 1.0 / cos(alpha);
	highp mat2 scale = mat2(scaleFactor, 0 , 0, scaleFactor);
	
	return rotate * scale * (a + translation) - translation;
}

void main()
{
	highp vec4 under = texture2D(my_color_texture, polar(tile_unclipped(rotate(unpolar(texture_coordinate)))));
	highp vec4 over = texture2D(my_color_texture, polar(tile(rotate(unpolar(texture_coordinate)))));
	gl_FragColor = over + (1.0 - over.a) * under;
}
