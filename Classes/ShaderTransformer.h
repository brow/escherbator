//
//  Image3DTransformer.h
//  Pano2
//
//  Created by Tom Brow on 9/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DataBackedCAB.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ShaderTransformer : NSObject {
	CGSize resolution;
	DataBackedCAB *contextAndBuffers;
	GLuint program;
}

- (id) initWithResolution:(CGSize)aResolution 
		 vertexShaderFile:(NSString *)vertexShaderFile 
	   fragmentShaderFile:(NSString *)fragmentShaderFile;
- (UIImage *) transformImage:(UIImage *)image;
@end
