//
//  Image3DTransformer.m
//  Pano2
//
//  Created by Tom Brow on 9/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShaderTransformer.h"
#import "Texture2D.h"

#define DEBUG

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
	ATTRIB_TEX_COORD,
    NUM_ATTRIBUTES
};

// Uniform index.
enum {
    UNIFORM_ALPHA,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

static const GLfloat photoVertices[] = {
	1,   1, 0,
	1,  -1, 0,
	-1,  1, 0,	
	-1, -1, 0,
};

static const GLfloat texCoords[] = {
	1,1,  1,0,  0,1,  0,0,
};

@interface ShaderTransformer()

- (BOOL)loadVertexShaderFile:(NSString *)vertShaderPathname fragmentShaderFile:(NSString *)fragShaderPathname;

@end


@implementation ShaderTransformer

- (id) initWithResolution:(CGSize)aResolution 
		 vertexShaderFile:(NSString *)vertexShaderFile 
	   fragmentShaderFile:(NSString *)fragmentShaderFile
{
	if (self = [super init]) {
		resolution = aResolution;
		contextAndBuffers = [[DataBackedCAB alloc] initWithWidth:resolution.width andHeight:resolution.height];
		
		[contextAndBuffers setAsOpenGLContext];
		[self loadVertexShaderFile:vertexShaderFile fragmentShaderFile:fragmentShaderFile];
	}
	return self;
}

- (void) dealloc
{
	if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
	
	[contextAndBuffers setAsOpenGLContext];
	[contextAndBuffers release];
	[super dealloc];
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadVertexShaderFile:(NSString *)vertShaderPathname fragmentShaderFile:(NSString *)fragShaderPathname
{
    GLuint vertShader, fragShader;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
	glBindAttribLocation(program, ATTRIB_TEX_COORD, "tex_coord");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
	
	// Get uniform locations.
    uniforms[UNIFORM_ALPHA] = glGetUniformLocation(program, "alpha");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

- (void) drawImage:(UIImage *)image {
	glUseProgram(program);
	
	// Update uniform value.
	glUniform1f(uniforms[UNIFORM_ALPHA], M_PI / 4.0);
	
	/* Set up attribute arrays. */
	glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 0, photoVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	glVertexAttribPointer(ATTRIB_TEX_COORD, 2, GL_FLOAT, 0, 0, texCoords);
	glEnableVertexAttribArray(ATTRIB_TEX_COORD);
	
#if defined(DEBUG)
	if (![self validateProgram:program]) {
		NSLog(@"Failed to validate program: %d", program);
		return;
	}
#endif

	/* Bind photo's texture. */
	Texture2D *texture = [[Texture2D alloc] initWithImage:image maxWidth:resolution.width*2 maxHeight:resolution.height*2];
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, [texture name]);
	glUniform1i(glGetUniformLocation(program, "my_color_texture"), 0);
	
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
	
	[self drawImage:image];
		
	return [contextAndBuffers toImage];
}

@end
