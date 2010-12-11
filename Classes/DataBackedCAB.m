//
//  DataBackedCAB.m
//  Pano1
//
//  Created by Tom Brow on 10/28/08.
//  Copyright 2008 Originate Labs. All rights reserved.
//

#import "DataBackedCAB.h"


@implementation DataBackedCAB

- (id) initWithWidth:(int)aWidth andHeight:(int)aHeight {
	if (self = [super init]) {
		width = aWidth;
		height = aHeight;
		
		[self setAsOpenGLContext];
		glEnable(GL_TEXTURE_2D);
		glGenRenderbuffersOES(1, &renderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
		[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:nil];
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_RGBA8_OES, width, height);
		glGenFramebuffersOES(1, &framebuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, framebuffer);
	}
	return self;
}

@end
