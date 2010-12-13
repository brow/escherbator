//
//  Shader.vsh
//  Shaders
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

attribute vec4 position;
attribute vec2 tex_coord;

varying vec2 texture_coordinate;

void main()
{
    gl_Position = position;
	texture_coordinate = tex_coord;
}
