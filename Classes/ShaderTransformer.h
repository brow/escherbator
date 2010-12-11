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

@interface ShaderTransformer : NSObject {
	CGSize resolution;
	DataBackedCAB *contextAndBuffers;
}

- (id) initWithResolution:(CGSize)aResolution;
- (UIImage *) transformImage:(UIImage *)image;
@end
