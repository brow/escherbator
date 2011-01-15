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

lowp float lnR2OverR1 = log(r2 / r1);

lowp vec2 polar(lowp vec2 a) {
	lowp float dist = exp(a.x * lnR2OverR1) * r1;
	lowp float angle = a.y * 2.0 * PI;
	return vec2(0.5 + dist * cos(angle), 0.5 + dist * sin(angle));
	
}

lowp vec2 unpolar(lowp vec2 a) {
	lowp vec2 v = a - vec2(0.5, 0.5);
	lowp float dist = sqrt(v.x * v.x + v.y * v.y);
	lowp float angle = atan(v.y, v.x);
	lowp float y = angle / (2.0 * PI);
	lowp float x = log(dist / r1) / lnR2OverR1;
	return vec2(x, y);
}

lowp vec2 scale(lowp vec2 a) {
	lowp float scaleFactor = (2.0 * PI) / lnR2OverR1;
	lowp mat2 scale = mat2(scaleFactor, 0 , 0, 1);
	return scale * a;
}

lowp vec2 unscale(lowp vec2 a) {
	lowp float scaleFactor = lnR2OverR1 / (2.0 * PI);
	lowp mat2 scale = mat2(scaleFactor, 0 , 0, 1);
	return scale * a;
}

lowp vec2 mod(lowp vec2 a) {
	return vec2(a.x - floor(a.x), a.y - floor(a.y));
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
	gl_FragColor = texture2D(my_color_texture, polar(mod(scale(rotate(unscale(unpolar(texture_coordinate)))))));
}
