//
//  ContextAndBuffers.h
//  Pano1
//
//  Created by Tom Brow on 10/28/08.
//  Copyright 2008 Originate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface ContextAndBuffers : NSObject {
	EAGLContext *context;
	GLuint renderbuffer, framebuffer;
	GLint width, height;
}

@property (readonly) GLint width;
@property (readonly) GLint height;
@property (readonly) GLuint renderbuffer;
@property (readonly) GLuint framebuffer;
@property (nonatomic, retain) EAGLContext *context;

- (id) init;
- (BOOL) setAsOpenGLContext;
- (void) present;
- (UIImage *) toImage;

@end
