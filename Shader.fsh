//
//  Shader.fsh
//  Shaders
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

varying lowp vec2 texture_coordinate; 
uniform sampler2D my_color_texture;

void main()
{
	gl_FragColor = texture2D(my_color_texture, texture_coordinate);
}
