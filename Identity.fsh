//
//  Shader.fsh
//  Shaders
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

varying lowp vec2 texture_coordinate; 
uniform sampler2D my_color_texture;

const highp float PI = 3.1415926535;
const highp float E = 2.71828183;

const lowp float r1 = 0.1;
const lowp float r2 = 0.5;

const lowp float lnR2OverR1 = log(r2 / r1);


lowp vec2 polar(lowp vec2 a) {
	lowp float angle = a.y * 2.0 * PI;
	lowp float dist = exp(a.x * lnR2OverR1) * r1;
	return vec2(0.5 + dist * cos(angle), 0.5 + dist * sin(angle));
}

lowp vec2 unpolar(lowp vec2 a) {
	lowp float angle = a.y * 2.0 * PI;
	lowp float dist = exp(a.x * lnR2OverR1) * r1;
	return vec2(0.5 + dist * cos(angle), 0.5 + dist * sin(angle));
}

lowp vec2 rotate(lowp vec2 a) {
	/* Translate by (0, -1) in order to rotate about lower-left corner. */
	lowp vec2 translation = vec2(0, -1.0);

	/* Rotate and scale to take upper-right corner to (0, 1). */
	lowp float angle = PI / 4.0;
	lowp mat2 rotate = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
	
	lowp float scaleFactor = sqrt(2.0);
	lowp mat2 scale = mat2(scaleFactor, 0 , 0, scaleFactor);
	
	return rotate * scale * (a + translation) - translation;
}

void main()
{
	gl_FragColor = texture2D(my_color_texture, polar(texture_coordinate));
}
