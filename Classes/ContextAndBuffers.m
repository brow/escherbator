//
//  ContextAndBuffers.m
//  Pano1
//
//  Created by Tom Brow on 10/28/08.
//  Copyright 2008 Originate Labs. All rights reserved.
//

#import "ContextAndBuffers.h"

void releaseImageBuffer (void *info, const void *data, size_t size) {
	free((void *)data);
}

@implementation ContextAndBuffers

@synthesize width;
@synthesize height;
@synthesize renderbuffer;
@synthesize framebuffer;
@synthesize context;

- (id) init {
	if (self = [super init]) {
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		if (!context || ![self setAsOpenGLContext]) {
			//TODO: this looks inadvisable 
			[self release];
			return nil;
		}
	}
	return self;
}

- (BOOL) setAsOpenGLContext {
	return [EAGLContext setCurrentContext:context];
}

- (void) present {
	[self setAsOpenGLContext];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (UIImage *) toImage {
	/* Copy frame buffer to image buffer. */
	uint imageBufferSize = width * height * 4;
	void *imageBuffer = malloc(imageBufferSize);
	glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, imageBuffer);
	
	/* Generate UIImage from image buffer. */
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, imageBuffer, imageBufferSize, releaseImageBuffer);
	CGImageRef cgImage =  CGImageCreate (
										 width,
										 height,
										 8,			/* bits per component */
										 8*4,		/* bits per pixel */
										 4*width,	/* bytes per row */
										 colorSpace,
										 kCGImageAlphaLast | kCGBitmapByteOrder32Big,
										 dataProvider,
										 NULL,
										 YES,		/* should interpolate */
										 kCGRenderingIntentDefault
										 );
	UIImage *ret = [UIImage imageWithCGImage:cgImage];
	
	/* Release intermediate data. */
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(dataProvider);
	CGImageRelease(cgImage);
	
	return ret;	
}

- (void) dealloc {
	if ([EAGLContext currentContext] != context)
		@throw [NSException exceptionWithName:@"GL Context Exception" 
									   reason:@"Tried to dealloc non-current context/buffers" 
									 userInfo:nil];

	glDeleteFramebuffersOES(1, &framebuffer);
	glDeleteRenderbuffersOES(1, &renderbuffer);
	[EAGLContext setCurrentContext:nil];
	
	[context release];
	[super dealloc];
}

@end
