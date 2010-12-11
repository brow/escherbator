//
//  Image3DTransformer.m
//  Pano2
//
//  Created by Tom Brow on 9/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShaderTransformer.h"
#import "Texture2D.h"

static const GLfloat photoVertices[] = {
	1,   1, 0,
	1,  -1, 0,
	-1,  1, 0,	
	-1, -1, 0,
};

static const GLfloat texCoords[] = {
	1,1,  1,0,  0,1,  0,0,
};


@implementation ShaderTransformer

- (id) initWithResolution:(CGSize)aResolution
{
	if (self = [super init]) {
		resolution = aResolution;
		contextAndBuffers = [[DataBackedCAB alloc] initWithWidth:resolution.width andHeight:resolution.height];		
	}
	return self;
}

- (void) dealloc
{
	[contextAndBuffers setAsOpenGLContext];
	[contextAndBuffers release];
	[super dealloc];
}


- (void) drawImage:(UIImage *)image {
	/* Set texture environment variables. */
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	
	/* Bind photo's texture. */
	Texture2D *texture = [[Texture2D alloc] initWithImage:image maxWidth:resolution.width*2 maxHeight:resolution.height*2];
	glBindTexture(GL_TEXTURE_2D, [texture name]);
		
	/* Set texture parameters. */
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	/* Set up vertex arrays. */
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, photoVertices);
	
	/* Draw. */
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	[texture release];
}

- (UIImage *) transformImage:(UIImage *)image {	
	/* Set up OpenGL context. */
	[contextAndBuffers setAsOpenGLContext];
	glViewport(0, 0, resolution.width, resolution.height);
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);

	/* Draw transformed image. */
	glPushMatrix();
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	[self drawImage:image];
	
	glPopMatrix();
	
	return [contextAndBuffers toImage];
}

@end
